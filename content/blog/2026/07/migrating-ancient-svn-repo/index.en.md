---
title: "Migrating an ancient SVN repo the painful way (tunnel vision included)"
date: 2026-07-28T00:00:00+02:00
draft: false
description: "A chronicle of escalating desperation: chunked dumps that tripped over their own chunk boundaries, a growing collection of Python tools that found more problems than they fixed, a 23 GB dump that svndumpfilter declared malformed, a dozen revisions mangled by a web server, and the three-command solution that made all of it unnecessary."
tags:
  - svn
  - backup
  - migration
  - sysadmin
categories:
  - post
authors: 
  - hypertesto
---

A while ago I inherited a ticking clock. The old internal server was finally being decommissioned, and sitting on it, alone by that point, like the last tenant of a building scheduled for demolition, was an SVN repository. 82,009 revisions. Fifteen years of commit history. 21 GB on disk. Set up by someone who left the company six years ago and has not been heard from since.

The requirements were simple on paper and annoying in practice. My coworkers (and some internal tools) needed to keep using SVN afterwards (`svn switch --relocate` and carry on with their lives), so migrating to git was off the table[^1]. I had to produce a working SVN repository somewhere else, ideally a slimmer one, because fifteen years of history include a couple dozen directories full of large binaries that nobody has needed since approximately the previous geological era.

[^1]: I did explore git briefly, mid-crisis, like a man checking the price of flights during a family dinner. The `git-filter-repo` tool is *vastly* better at path-based filtering than anything SVN offers, but the deliverable was a working SVN endpoint. Technical debt, eh?

What follows is the honest, chronological reconstruction of what happened next. I'm writing it as a series of attempts because that's literally what it was: each failure manufactured the problem that the next attempt would heroically fail to solve. And since I'm an engineer before I'm a storyteller, every attempt closes with its lab notes: what I wanted, what I fed in, and what came out. The outcome column is where the comedy lives.

## Attempt one: the obvious one

The goal, at the beginning, was simple: get all 82,009 revisions out of that server and onto a disk I controlled. So I started where everyone starts:

```bash
svnrdump dump https://svn.server/repo > full.dump
```

One command, one file, one prayer. I knew it wasn't going to work (~82,000 revisions over a flaky connection means any hiccup sends you back to revision zero), but you have to try the obvious thing first, if only out of respect for tradition.

I let it run overnight. It died at 4 a.m. somewhere in the low thirty-thousands, which I choose to read as the repo setting my expectations early.

{{< alert "pencil" >}}
**Intent:** a complete dump of the repository, in a single file.<br/>
**Input:** the repo URL, one `svnrdump` command, blind optimism.<br/>
**Outcome:** a partial dump (~30k revisions in), one dead process, nothing usable.
{{< /alert >}}

## Attempt two: divide and conquer

Fine. If the pipe won't survive six hours, don't run a six-hour pipe. The new plan: slice the dump into 2,000-revision chunks, compress each one as it lands, and track progress in a manifest file so the whole thing could resume from the last checkpoint instead of from revision zero:

```bash
CHUNK_SIZE=2000

while [ "$CURRENT_START" -lt "$LATEST_REMOTE" ]; do
    END_REV=$((CURRENT_START + CHUNK_SIZE))

    svnrdump dump "$REPO_URL" -r "${RANGE_START}:${END_REV}" | \
    gzip > "${CHUNK_NAME}.tmp"

    # only on success: promote the chunk and checkpoint
    mv "${CHUNK_NAME}.tmp" "$CHUNK_NAME"
    echo "$END_REV" > "$MANIFEST"
done
```

Note the `.tmp` dance: a chunk only earns its real name once `gzip` closes cleanly, so a killed run never leaves a half-written file masquerading as a good one. I was learning. Slowly, and at great cost, but learning.

And it *worked*. The network could drop, the process could be killed, I could free disk between iterations, and the script just resumed from the manifest. By the end of the day I had, for the first time, a complete dump of the repository: forty-one gzipped chunks covering every revision from zero to 82,009.

The victory lasted about ten minutes: roughly the time it took to run `du -sh`. The output was too large for the destination server's disk. Which meant I now needed to filter the dump. And that's where the real trouble started, though I didn't know it yet.

{{< alert "pencil" >}}
**Intent:** a dump that survives network drops, OOMs and disk-pressure, resumable by construction.<br/>
**Input:** the repo URL, `CHUNK_SIZE=2000`, one manifest file as checkpoint.<br/>
**Outcome:** complete success, technically: 41 chunks, all revisions present, total size larger than the destination disk. Also, though I didn't know it yet, every chunk was a self-contained time bomb. More on that shortly.
{{< /alert >}}

## Attempt three: divide, conquer, filter

The natural next move was splicing `svndumpfilter exclude` into the pipeline, dropping ~20 paths that were no longer needed[^2]: old project archives, documentation builds from 2011, subprojects that had long since been split into their own repos:

```bash
EXCLUDES=(
    "/research_project3.1518684973-ver3.9-FINAL.pdf"
    "/P1-P2-Help-Desk(chunking).docx"
    "/com.acme.textprocessing.a"
    "/com.acme.textprocessing.b"
    "/com.acme.textprocessing.c"
    "/com.acme.textprocessing.d"
    "/legacyDoc"
    "/legacy-utils"
    "/customerX"
    # ... ~20 entries total
)

svnrdump dump "$REPO_URL" -r "${RANGE_START}:${END_REV}" | \
    svndumpfilter exclude $EXCLUDE_ARGS | \
    gzip > "${CHUNK_NAME}.tmp"
```

It failed at the chunk boundaries:

```text
svndumpfilter: E200003: Invalid copy source path '/legacy-utils/trunk/...' for '/SomeOtherProject/trunk/...'
```

Two discoveries, neither pleasant. First: `svndumpfilter` matches path *prefixes* only: no wildcards, no regex, no substring matching. `com.acme.textprocessing.a` is not considered "inside" `com.acme.textprocessing`, because SVN treats dots literally, not as directory separators. Second, and much worse: if revision 8,342 copies a file *from* a path you're excluding *to* a path you're keeping, the dump stream references a source that no longer exists. `svndumpfilter` hits it, stops, and provides no `--skip-broken-references` flag. No recovery, no partial output.

Fifteen years of directory moves, project renames, and module splits meant the copy-from graph was deeply tangled. I could either abandon filtering, or understand the dependency structure well enough to navigate around it.

I chose poorly.

{{< alert "pencil" >}}
**Intent:** same resumable chunked dump, minus ~20 directories of dead weight.<br/>
**Input:** the attempt-two pipeline with `svndumpfilter exclude` spliced in, plus one lovingly curated exclude list.<br/>
**Outcome:** `E200003` at chunk boundaries, zero usable output, and two unpleasant facts about `svndumpfilter` learned the hard way.<br/>
{{< /alert >}}

[^2]: Yes, one of the files I was trying to exclude was literally named `Help-Desk(chunking).docx`. Fifteen years in advance, the repo was already mocking my strategy.

## Attempt four: the Python era

This was around day three, and the point where a backup migration quietly turned into a software project. The plan: before touching `svndumpfilter` again, map the entire copy-from graph of the repository and find out, with data rather than hope, whether any exclude set could ever work.

I wrote `analyze_svn_chunks.py`, a binary-streaming scanner that reads every chunk file's `Node-path`, `Node-copyfrom-path`, and `Revision-number` headers and builds a global map of every copy-from dependency:

```python
REV_RE      = re.compile(rb'^Revision-number:\s*(\d+)$')
NODE_PATH   = re.compile(rb'^Node-path:\s*(.+)$')
NODE_COPYFROM = re.compile(rb'^Node-copyfrom-path:\s*(.+)$')

for chunk in sorted_chunks:
    for line in iter_lines_binary(chunk):
        # track first_seen[path], path_locations, copyfrom_refs...
```

It was later joined by two reconnaissance siblings: `find_copyfrom_prefixes.py`, which lists every copy-from source sitting under the prefixes I wanted to exclude, and `find_svn_copy_nodes.py`, which flags copy nodes that a given include/exclude list would leave orphaned. I was no longer migrating a repository; I was running a small research institute.

The findings: **8,172 unique copy-from sources**, summarized in four report files: `copyfrom_sources.txt`, `copyfrom_report.json`, `missing_sources.txt`, and, critically, `sources_in_excludes.txt`: copy-from paths sitting *inside* the very directories I wanted to exclude. Dozens of them. There's a special kind of sinking feeling reserved for the moment a tool you wrote outputs formal proof that your plan cannot work. `svndumpfilter` was structurally incapable of handling this exclude set, full stop.

Fine, I thought: filter later, load first. Except even the *unfiltered* chunks refused to load into a test repository:

```text
svnadmin: E160020: File already exists: filesystem '...', path '/acmemmf'
```

The reason, once I dug in: every chunk was self-contained. When a new chunk started at revision 5001, `svnrdump` re-emitted `Node-action: add` for every file that already existed in the repository. `svnadmin load` would see a path it had already created from the previous chunk and crash. So I wrote a second kind of tool, `svn_dump_repair.py`, to rewrite the duplicate adds into changes, tracking path state in a dictionary shared across all chunks:

```python
def repair_bytes(src, dst, existing=None):
    # existing: cross-chunk shared dict {path(bytes) -> first_rev(bytes)}
    # streaming binary parse, track cur_path/cur_action,
    # if cur_action == b'add' and cur_path in existing:
    #     replace ACTION_ADD with ACTION_CHG
```

And this is where things got *properly* worse, because the first version opened the dump with `encoding='utf-8', errors='replace'`. SVN dump files contain raw binary diffs. The `errors='replace'` setting silently swapped in replacement characters for invalid bytes. In other words, my repair tool was corrupting the very diffs it was supposed to preserve. Loading the "repaired" chunks gave:

```text
svnadmin: E185001: Svndiff contains a too-large window
```

There's probably a metaphor in there about fixing things by breaking them harder, but I was too busy to look for it. I rewrote the script to process everything in raw binary mode (`rb`/`wb`), touching only the header lines it actually needed to inspect. Binary pass-through for everything else. (The docstring of the final version still carries the scar: *"Processes everything in BINARY mode to avoid corrupting SVN diff data."*)

Only then did I find the real root cause, and it stung: I wasn't using `--incremental`. The dump format has no primitive for "the repository already has this path from a previous load." Every chunked dump without `--incremental` is a self-contained stream that re-describes the entire filesystem state at its starting revision. The first chunk needs a full dump; every subsequent chunk must be `--incremental`. The 8,172 copy-from sources, the E160020 crashes at chunk boundaries: the same underlying problem wearing different hats. A small zoo of Python scripts, and the fix was a flag.

{{< alert "pencil" >}}
**Intent:** first, map the copy-from web to find a viable exclude set; then, bend the chunks until they loaded in sequence.<br/>
**Input:** chunk files + `excludes.txt` into the analyzer; chunk files + one shared cross-chunk state dict into the repair tool.<br/>
**Outcome:** a JSON file formally proving my filtering plan impossible; a repair tool that first corrupted the data (E185001), then worked, then became unnecessary the moment `--incremental` entered my life.
{{< /alert >}}

## Attempt five: things get worse before they get... no, they just get worse

This was day four. Or five. I'd stopped counting, and had started naming scripts things like `fix_dump_FINAL.py`, which anyone will recognize as a bad omen.

The new, corrected pipeline: first chunk full, every subsequent chunk dumped with `--incremental`, filtering removed entirely. Surely, *surely*, loading the unfiltered chunks would now work. It did not:

```text
svnadmin: E160013: File not found: transaction '...', path '/com.acme.esb/...'
svnadmin: E200014: Base checksum mismatch on '/acmemmf/trunk/...'
```

These were copy-from references pointing at source revisions that weren't present in the chunks loaded so far, because some earlier chunk had failed silently along the way. Files copied from revision 17,711 into revision 66,669, with revision 17,711 nowhere to be found. The chunking strategy wasn't just fragile; it was fragile *and* quiet about it, which is the worst combination.

{{< alert "pencil" >}}
**Intent:** load the unfiltered, properly-incremental chunks and finally have a working local copy.<br/>
**Input:** the fresh `--incremental` chunk set.<br/>
**Outcome:** `E160013` and `E200014`: references to source revisions that never made it into the dump, courtesy of earlier silent failures.
{{< /alert >}}

## Attempt six: one dump to rule them all

New strategy, and I want you to know it felt clever at the time: dump the entire repo unfiltered, in one logical pass, with `--incremental` on everything except the first chunk. Concatenate all chunks locally into a single stream. Then run `svndumpfilter` exactly once, on the combined file. Two passes, clean separation of concerns. What could possibly…

The concatenated unfiltered dump came out to **23 GB** compressed.

I ran the second pass:

```bash
zcat filtered_1st_pass.dump.gz | \
    svndumpfilter exclude --drop-empty-revs $EXCL_ARGS | \
    gzip -c > filtered_2nd_pass.dump.gz
```

And the answer was:

```text
svndumpfilter: E140001: Dumpstream data appears to be malformed
```

Twenty-three gigabytes of compressed history, and the verdict was: *malformed*. No offset. No line number. No partial output. No `--skip-malformed` flag to reach for. The process stopped, took its ball, and went home.

That was the breaking point. I closed the terminal, made a coffee, and admitted to myself that I had just lost a week-long fight against a text file format.

{{< alert "pencil" >}}
**Intent:** one complete logical dump, filtered exactly once, clean separation of concerns.<br/>
**Input:** all chunks concatenated into a single 23 GB compressed stream.<br/>
**Outcome:** `E140001`, no offset, no mercy. One (1) coffee of defeat.
{{< /alert >}}

## The light at the end of the tunnel was... a tunnel

Defeated people do honest things, so I did what I should have done on day one: I stopped skimming the SVN Book for flags and actually *read* it. And there it was, sitting in plain sight the whole time: `svnsync`, SVN's built-in mirroring tool.

`svnsync` replicates a repository revision by revision over the network using SVN's own protocol. No dump files. No filtering. No manual parsing of `Node-copyfrom-path` headers. Copy-from references, `svn:mergeinfo`, property changes. All first-class concepts in the wire protocol, handled natively.

I pointed it at the same `https://` endpoint that `svnrdump` had been talking to all along, and at first it felt like the happy ending. It resumed after connection drops. It chugged along, revision by revision. And then the checksums started failing: about a dozen revisions came out corrupted. I wiped the mirror, retried, and got the same dozen, give or take, and they were always the heavy ones, the revisions carrying the big binaries.

The culprit wasn't SVN. It was Apache. Over `https://`, Subversion doesn't speak its native protocol at all: it speaks WebDAV/DeltaV through `mod_dav_svn`, which lives inside an Apache worker process. Every operation becomes an HTTP request with an XML payload, and everything runs under the web server's resource governance: per-process memory limits, request timeouts, MPM tuning. When my sync pushed a multi-hundred-megabyte delta through, the httpd child handling it ballooned, hit its memory ceiling, and died mid-stream. What landed in my mirror was a truncated revision and a checksum mismatch.

The obvious fix was to raise Apache's memory limit and try again. But blindly bumping a limit you don't understand just moves the wall a bit further: the next fatter binary would have found the new ceiling eventually. So I finally used my so-called brain and asked a better question: what is a web server doing in the middle of my data transfer at all?

Because, and this is the part I find genuinely interesting, SVN wasn't born speaking `svn://`. The project started life as an Apache module; WebDAV was the *original* transport, and `svnserve` only arrived later, for people who didn't feel like running an entire web server just to version their code. The two transports are wildly different animals:

| | `https://` (mod_dav_svn) | `svn://` (svnserve) |
|---|---|---|
| Transport | HTTP requests with XML payloads (WebDAV/DeltaV) | Purpose-built binary protocol over a stateful TCP connection |
| Server process | Apache worker, subject to its memory and timeout limits | Small dedicated daemon with a modest, predictable footprint |
| Payload | Native deltas wrapped in HTTP/XML envelopes | Native deltas, streamed as-is |
| Middlemen | A full web server that may decide your 2 GB delta looks like an attack | None |

In short: `https://` makes SVN traffic look like web traffic: fantastic for slipping through corporate proxies, terrible for shoveling gigabytes of binary history from A to B. `svn://` is the protocol SVN speaks when nobody forces it to wear a costume.

And here's the part that still makes me laugh. As far as I know, this repository has been served through Apache for its entire fifteen-year existence, most of it on a machine considerably weaker than the one it retired from. Which means every single one of those monster binaries went *in* through the very same web server that was now fainting at the sight of them coming out[^3]. Committing, apparently, was perfectly fine. Reading back was where the web server drew the line.

[^3]: The files checked in any time they liked, but they could never leave.

To be fair, there is a real asymmetry: on commit, the client does the heavy lifting and hands the server a ready-made delta to store; on read, `mod_dav_svn` has to reconstruct and stream those deltas itself, on its own memory dime. And fifteen years of commits arrived one polite transaction at a time, over a LAN, with nobody in a hurry. I showed up asking for everything, all at once, the digital equivalent of draining a swimming pool through the same straw people had used to fill it.

The catch: the source server didn't expose `svn://` to the network. It sat on an internal subnet reachable only through a jump host. But the jump host had SSH, and SSH is the universal solvent:

```bash
ssh -L 3690:10.0.0.3:3690 svn-machine

# in another terminal:
svnsync init file:///tmp/svn_dest_repo svn://localhost:3690
svnsync sync file:///tmp/svn_dest_repo
```

Three commands. I typed them with the confidence of a man who had already been betrayed four times that week, and waited.

It just worked. Revision after revision, ticking upward, unbothered. When the connection dropped (of course it dropped), `svnsync sync` simply resumed from the last checkpointed revision. The SSH tunnel (`-L local_port:remote_host:remote_port`) gave me a stable, encrypted pipe through the firewall: `localhost:3690` on my machine mapped to `10.0.0.3:3690` on the source, with the jump host doing the routing. The two servers never needed to see each other at all.

The whole 21 GB came across, binaries and all, and this time the verification pass came back clean. All 82,009 revisions, not one byte out of place. The same tool that had mangled a dozen revisions over DAV didn't put a single one wrong over `svn://`[^4].

[^4]: Yes, unfiltered: the poisoned directories came along for the ride. Disk is cheap. My sanity, at that point, was not.

{{< alert "pencil" >}}
**Intent:** replicate the repository using SVN's own protocol: no dumps, no filters, no text parsing.<br/>
**Input, take one:** `svnsync` over the existing `https://` endpoint → a dozen corrupted revisions, always the heavy ones (Apache OOM mid-delta).<br/>
**Input, take two:** `svnsync` over `svn://` through an SSH tunnel → 82,009 revisions, verification clean, zero corrupted. One week of my life not coming back.
{{< /alert >}}

## Why the boring tool won

In hindsight, the dump pipeline and `svnsync` attack the same problem from opposite directions. The pipeline is a serial, single-shot transformation chain: `svnrdump` reads raw repo data, `svndumpfilter` removes paths by parsing text, `gzip` compresses bytes. Each tool speaks a different abstraction level, and any failure anywhere kills the whole operation, usually silently, occasionally at 4 a.m.

`svnsync` never leaves SVN's own protocol, at least not once you let it use the native one. It negotiates revisions, transfers native deltas, checkpoints atomically. It doesn't parse dump headers because it doesn't need dump headers; it doesn't trip over copy-from references because the protocol resolves them for it. And it *resumes*, which, for an 82,000-revision transfer, is the entire difference between a tool and a gamble.

Though, as the corrupted dozen taught me, even the right tool needs the right transport. Every layer you stack between the two repositories (HTTP, XML, a web server with opinions about memory) is another place where your data can get quietly truncated.

The irony is not subtle: `svnsync` is the tool the SVN documentation recommends for mirroring. It was there from the start. I just had to fail with chunked dumps, a growing pile of Python scripts, and a 23 GB malformed file before I was emotionally ready to accept it[^5].

[^5]: If you're reading this because you're staring down your own ancient SVN migration: try `svnsync` first. The dump pipeline is a trap. Do not be me.

## Epilogue

The mirror completed. The old server, at the time of writing, is still standing, but its successor is ready, and keeping it warm until the cutover costs exactly one command: `svnsync sync`, the very same one, which simply fetches whatever revisions landed in the meantime. Put it in a cron job and the mirror maintains itself while everyone keeps committing to the old repo, blissfully unaware.  
Somewhere on a disk there's still a directory of chunked dump files, four Python scripts, and a 23 GB compressed artifact that `svndumpfilter` once called malformed, none of which I will ever touch again, which is exactly the right fate for tools written in desperation[^6].

[^6]: If there's a silver lining, it's that a week of poking compressed SVN dumps makes you genuinely fluent in `zcat`, `zgrep`, `zless`, `gzip -t`, and the fine art of binary-safe stream processing. Not skills I wake up wanting to practice, but surprisingly transferable.

I spent a week engineering increasingly elaborate solutions to problems that only existed because of the approach I'd chosen. The answer was never better filtering, better chunking, or better binary parsing. It was to stop fighting the dump format and use the protocol instead.

Also: SSH tunnels are magic, `svnsync` deserves far more respect than its own documentation gives it, and the next person to commit a multi-gigabyte binary to version control will be judged: silently, professionally, but intensely.

Thanks for ~~dumping~~ reading!
