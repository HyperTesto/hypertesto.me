---
title: "From 30GB of garbage to 3GB: JVM optimization with an AI assistant on a leash"
date: 2026-08-12T10:00:00+02:00
draft: false
description: "Profiling-driven JVM optimization that cut allocations from 30GB to under 3GB, with AI agents, a scruffy AGENTS.md and a human on the flame graphs."
tags:
  - java
  - kotlin
  - jvm
  - performance
  - profiling
  - AI
  - GC
categories:
  - programming
authors:
  - hypertesto
---

Earlier this year a component I work on started making itself unpopular. The codebase is a Java engine, mostly rule-based, and it predates me at the company by some years: its original author left, and since then it has been maintained the way you maintain a gym subscription. _In theory_.

The monitoring showed a number that was hard to unsee: over 30GB of heap allocated by a single instance, nearly all of it dead within seconds of being born. The damage had a specific trigger: generating a report means evaluating every variant against every rule in the engine, and with a large enough domain the process would eat every gigabyte the dev VM had. We restarted it on a regular basis, which worked fine until the restarts started leaving zombie processes behind.[^A] The GC graph looked like the cardiogram of someone who has just seen the restaurant bill.

{{< figure src="memory_before.png" alt="Memory allocations before the optimizations" caption="Memory allocations before most of the optimizations" >}}

Production, for the record, never saw any of this: the expensive path only runs while building that report. Small mercies.

[^A]: Dead but still holding on to the PID, which is more job security than most of us get.

A few months later the same workload allocates less than 3GB. This post covers the optimization techniques that got us there, but it is also my first real success case of AI-assisted coding, and a late one: agents, instruction files, skills, all common knowledge for at least two years, and I had never found the time or the right occasion to apply any of it methodically. A legacy codebase that nobody wanted to touch turned out to be exactly the right occasion. I had a pair programmer for the whole campaign, and it was an AI coding assistant: tireless, immune to boilerplate, and fully capable of suggesting a rewrite so elegant it made everything slower.[^1]

[^1]: We'll get there. The benchmarks got there first, luckily.


## The method is the story

Before touching a single class, we built the harness.

Harness is a grand word for the boring infrastructure that answers two questions after every change: did I break anything, and did it help. On a codebase you know well you can sometimes answer both from memory; on a seven-year-old engine whose author left the company, you can't, and I had no intention of learning the answer the hard way. There was also a newer reason: I was about to let an AI assistant propose changes to code that neither of us fully understood. The assistant would be confident about all of them, so every suggestion needed a way to be proven wrong. And for performance work the stakes double, because allocation pressure is invisible in a diff and only shows up as a number.

{{< alert "comment" >}}
You you are looking for a definition of "agent harness", there's no better place than [wikipedia](https://en.wikipedia.org/wiki/Agent_harness).
{{< /alert >}}

Three pieces, in the order we built them:

1. **A memory-pressure test.** One test feeds the engine a realistic input corpus and the profiler reports how much it allocates, so "memory pressure" became a number on a page instead of a feeling in the pit of my stomach. This is the test that said 30GB out loud.
2. **Characterization tests with coverage.** Tests pinning the current behaviour of every class we planned to touch, coverage report included, so we could see what was protected and what was wishful thinking. Current behaviour means all of it, bugs included: a characterization test describes what the code does, not what it should do, and fixing a bug by accident during a refactor is still a change that someone downstream may depend on. In the immortal words of Linus Torvalds: "Do not break userspace". Legacy code without these tests is a museum: you can look, but you can't touch.
3. **[JMH benchmarks](https://github.com/openjdk/jmh) for the hot spots.** `Ontology`, `PropertyStore`, `ReduceExpression` and `RuleMatch` each got a suite measuring throughput and bytes allocated per operation, before any change. Baselines first, heroics later.

Then the loop, repeated for every offender the profiler coughed up: change one thing, run the tests, run the benchmark, profile again. Every commit shipped with an `optimization:` prefix, so the paper trail is unusually tidy for once.

This loop is also why the campaign became my first real success case of AI-assisted coding, after previous attempts that had produced mostly confident nonsense. The difference came from agentic mode: instead of relaying snippets between a chat window and the IDE, the assistant could run the tests, launch the benchmarks, read the failures and iterate on its own, while I supervised. Writing a JMH suite for four classes is an afternoon of soul-crushing boilerplate for a human; for the agent it was minutes, and it never once complained about it.

The other half of the trick was embarrassingly low-tech: a very basic [`AGENTS.md`](https://agents.md/) at the root of the repo, plus a couple of [skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview). The file explains how the project builds, how to run the suites, and the house rules: pin the behaviour with tests before touching a legacy class, and no speedup claims without a benchmark. The skills cover the repeatable chores, like scaffolding a benchmark or generating characterization tests for a class nobody remembers writing. Total investment: one evening. In exchange the assistant stopped asking questions the README could answer, and I stopped being the slowest stage of the pipeline. The machine did the typing, my job was reading profiles and applying vetoes. That last verb will matter later.

## Human in the loop, by accident

The crew, for the record: 
- [Junie](https://junie.jetbrains.com/) running on Claude and Gemini models for most of the campaign
- [Copilot](https://github.com/copilot) with auto model selection, which in practice meant GPT models.  

Two different setups, same `AGENTS.md`, same house rules.

The division of labour between me and the agents was decided by the filesystem, not by design. Coverage reports live inside the project directory, so the agents read them on their own without any MCP server or special tooling: they just opened the files like anything else in the repo. The profiler was another story. I used IntelliJ's built-in profiler, which saves its snapshots outside the project directory, so the agents never saw a single flame graph.

That limitation became the most useful feature of the setup. Every round went the same way: I read the [flame graph](https://en.wikipedia.org/wiki/Flame_graph), picked the offender, pointed the agent at it, then looked at the diff and decided whether to keep refining or move on to the next hotspot. No agent could shortcut the process by going off-script on a profile I hadn't shown it, and I had a permanent excuse to understand the code instead of rubber-stamping diffs.

_Human in the loop, enforced by a file path 😅._

The other rule I enforced by hand was atomicity: one optimization per commit, small enough that a regression could be identified and reverted in minutes. The agents accepted this in principle. In practice the GPT models tried more than once to bundle a grand rewrite into a single confident diff, and the answer was always the same: "Nice, HELL NO". I held the line almost every time. The "almost" gets its own chapter in a minute.

## Greatest hits of the garbage era

What follows is the changelog of shame, in rough order of appearance. Each one started with the profiler pointing at something embarrassing and ended with the benchmark deciding whether the fix counted.

**The clone that serialized itself.** Input objects get duplicated all the time to build processing variants, and the old `copy()` did it by serializing to JSON and parsing the result straight back:

```java
// InputText.java
 public InputText copy() {
-    return parseJSON(toJSON());
+    return new InputText(this);
 }
```

Every call meant `StringBuilder` reallocations, a crowd of transient strings, recursive map building during parsing: a small landfill per invocation. Swapping the JSON round-trip for plain copy constructors across the `Input` classes removed one of the top churn sources in a single commit. The old version had survived for years because it was two lines long and obviously correct. It was also obviously expensive :-).

**Manual array juggling.** `RuntimeNode.getLeafNodes` collects leaf nodes during recursive rule matching, and it managed its results by hand: fixed-size arrays grown with `Arrays.copyOf`, stitched together with `System.arraycopy` at every level of the tree.[^B] Gigabytes of short-lived arrays, gone. The replacement is a `ThreadLocal` pooled `ArrayList`, plus a recursion guard because a traversal can re-enter itself through dynamic property evaluation:

```java
private static final ThreadLocal<ArrayList<RuntimeNode>> LEAF_COLLECTOR =
    ThreadLocal.withInitial(() -> new ArrayList<>(32));
private static final ThreadLocal<Integer> LEAF_DEPTH = ThreadLocal.withInitial(() -> 0);

private ArrayList<RuntimeNode> getLeafNodes(Context context) {
    int depth = LEAF_DEPTH.get();
    if (depth > 0) return new ArrayList<>(16); // re-entrant call: don't touch the pool
    LEAF_DEPTH.set(1);
    try {
        ArrayList<RuntimeNode> out = LEAF_COLLECTOR.get();
        out.clear();
        collectLeafNodes(context, out);
        return new ArrayList<>(out);
    } finally {
        LEAF_DEPTH.set(0);
    }
}

private void collectLeafNodes(Context context, ArrayList<RuntimeNode> out) {
    // boring stuff, mostly to include external domains as children
    // ...

    if (!hasChildren()) {
        out.add(this);
        return;
    }

    for (RuntimeNode child : childrenNodes) {
        if (child.isEnabled(context)) child.collectLeafNodes(context, out);
    }
}
```

The guard looks paranoid until you remember that corrupting a shared buffer is the kind of bug that pages you at 3am.

[^B]: My personal theory is that this code started life as a transliteration of an older PHP implementation, where growing arrays by hand raises no eyebrows. It's a conjecture: I have no proof, just the same feeling you get when you recognize someone's accent.

**O(N) lookups with a side of toLowerCase.** Node properties lived in a flat array, scanned linearly, with case-insensitive comparisons allocating lowercase key copies along the way. The assistant rewrote the container as `PropertyStore`: a `LinkedHashMap` indexed by a `LowerKey` wrapper that caches the hash. The diff, in all its glory:

```java
-    private RuntimeProperty[] properties = new RuntimeProperty[0];
+    private final PropertyStore propertyStore = new PropertyStore();

 public RuntimeProperty getProperty(String key, Context context) {
-    for (RuntimeProperty property : properties) {
-        if (!property.lowerKey.equals(lowerKey)) continue; // key.toLowerCase() churn
-        // ...
-    }
+    return propertyStore.get(key, context);
 }
```

The store itself, abridged (the full version has the usual mutation and serialization plumbing):

```kotlin
internal class PropertyStore : Serializable {

    /** Ordered storage preserving insertion order. */
    private val properties = mutableListOf<RuntimeProperty>()

    /** lowerKey -> indices into [properties]: case-insensitive lookup without String allocation */
    private val index = LinkedHashMap<LowerKey, MutableList<Int>>()

    /** The hot-path method. */
    fun get(key: String, context: Context?): RuntimeProperty? {
        val indices = index[LowerKey(key)] ?: return null
        // iterate only the candidates for this key; first match wins,
        // and multiple matches get resolved randomly (legacy behaviour, don't ask)
        // ...
    }

    private class LowerKey(private val key: String) {
        private var hash: Int = 0
        private var hashComputed: Boolean = false

        override fun hashCode(): Int {
            if (!hashComputed) {
                var h = 0
                for (i in key.indices) {
                    h = 31 * h + key[i].lowercaseChar().code
                }
                hash = h
                hashComputed = true
            }
            return hash
        }

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other !is LowerKey) return false
            return key.equals(other.key, ignoreCase = true)
        }
    }
}
```

The interesting part is `LowerKey`: it computes the hash by lowercasing one character at a time, caches the result, and compares keys with `equalsIgnoreCase`, so a lookup never builds a lowercased copy of the key. One legacy quirk survived the rewrite on purpose: if several properties share a key, `get()` picks one at random, because the old array did. Exactly the kind of behaviour you want pinned by a test before touching anything, since someone, somewhere, depends on it.

Lookups went from a linear scan to O(1), and about 400MB of daily allocation evaporated in the benchmark. Note the language of this class: *Kotlin*. Remember this detail in a couple of paragraphs.

**The ontology that allocates nothing.** Concept resolution hit a `HashMap<String, String>` thousands of times per request, paying `Map.Entry` allocations and temporary normalized keys every single time. The replacement, `OntologyOptimized`, is a small open-addressing table over an `IntArray`, with a case-insensitive hash computed directly on the characters:

```kotlin
class OntologyOptimized : Serializable {

    // Parallel arrays in insertion order: no Map.Entry objects anywhere.
    private var keys   = arrayOfNulls<String>(INIT_CAP)
    private var values = arrayOfNulls<String>(INIT_CAP)

    // Open-addressing table, power-of-two capacity so masking replaces modulo.
    // Each cell holds an index into keys/values, or EMPTY (-1).
    private var table     = IntArray(INIT_TABLE) { EMPTY }
    private var tableMask = INIT_TABLE - 1

    /** Case-insensitive hash folded over the original chars. Zero allocations. */
    private fun hashCI(key: String): Int {
        var h = 0
        for (ch in key) h = 31 * h + Character.toLowerCase(ch.code)
        return h
    }

    /** Linear probe: the slot either holds the entry's index or is where it should go. */
    private fun probe(key: String): Int {
        var slot = hashCI(key) and tableMask
        while (true) {
            val idx = table[slot]
            if (idx == EMPTY || keys[idx]!!.equals(key, ignoreCase = true)) return slot
            slot = (slot + 1) and tableMask
        }
    }

    /** The hot path. Zero allocations. */
    fun getValue(key: String): String? {
        val idx = table[probe(key)]
        return if (idx == EMPTY) null else values[idx]
    }
}
```

The write path, not shown, is equally boring on purpose: existing keys get updated in place, and the table grows by doubling when the load factor says so. `getValue`, `contains` and `getIntegerValue` all go through `probe`, so lookups here allocate zero bytes, and this is my favourite kind of optimization: the one where the allocation profiler just goes quiet.

**Death by a thousand replace().** Input normalization was a chain of `String.replace()` calls, each producing a fresh string. The replacement, only slightly abridged:

```java
private static String normalizeSentenceText(String sentenceText) {
    String text = sentenceText != null ? sentenceText : "";
    text = text.toLowerCase(getLocale()).trim();

    // every apostrophe flavor becomes "' ": ', ’, ‘, `
    StringBuilder withApostrophesNormalized = new StringBuilder(text.length() + 8);
    for (int i = 0; i < text.length(); i++) {
        char ch = text.charAt(i);
        if (ch == '\'' || ch == '’' || ch == '‘' || ch == '`') {
            withApostrophesNormalized.append('\'').append(' ');
        } else {
            withApostrophesNormalized.append(ch);
        }
    }

    String compactSpaces = compactSpaces(withApostrophesNormalized);
    StringBuilder withPunctuationSeparated = new StringBuilder(compactSpaces.length() + 16);

    for (int i = 0; i < compactSpaces.length(); i++) {
        char ch = compactSpaces.charAt(i);
        if (isRemovalCharacter(ch)) {
            withPunctuationSeparated.append(' ').append(ch).append(' ');
        } else {
            withPunctuationSeparated.append(ch);
        }
    }

    return withPunctuationSeparated.toString();
}
```

Strictly speaking that's two passes plus a space compaction, each with its own pre-sized builder, which still beats a dozen full-string reincarnations by a wide margin. My favourite detail is the apostrophe zoo: four different Unicode characters, all normalized to the same boring ASCII one, because Italian text on the internet comes in all fonts. Nobody will ever notice this code, hopefully.

**A bouncer for the rule engine.** Most semantic rules can't possibly match a given input, and the engine was evaluating them anyway. The new prefilter puts a Bloom filter up front for cheap rejection and a `BitSet` for exact membership on required token ids, so hopeless rules get skipped for almost nothing:

```kotlin
fun maybeContainsAll(requiredTokenIds: IntArray): Boolean {
    if (strategy == Strategy.EXACT_ONLY) return containsAll(requiredTokenIds)
    for (id in requiredTokenIds) {
        if (!bloom.mightContain(id)) return false
    }
    return true
}
```

We implemented both membership strategies and profiled them on real data: the plain bitset won. Measure on real inputs, because the elegant option is not guaranteed to be the fast one. Which brings us to the next chapter.

## The chapter where the assistant made it slower

After all the wins above, what remained was the match engine itself: deep nesting, special cases glued to other special cases, control flow nobody would design on purpose. The assistant proposed the obvious move, and in a moment of weakness I agreed _(a GPT model, since you're keeping score)_: rewrite it in idiomatic Kotlin. The nesting collapsed into `none {}` chains, `when` replaced the if-ladder, lambdas everywhere. *Beautiful*. The tests, dozens of them by then, stayed green the whole time.

The benchmark got worse both on memory and throughput.

I re-ran it assuming a measurement mistake, then re-checked the profiler setup. The regression survived both. With hindsight the reasons are not even exotic: lambdas capturing `ctx` at every level allocate, scope functions allocate, and HotSpot had spent years getting extremely good at running the ugly, predictable, monomorphic loops that the old Java happened to be. We had re-introduced allocation on the exact path where we had just finished removing it. Idiomatically.

Without the harness we would have merged it anyway, because it reads better, and a week later we would have been in production wondering what had changed. With the harness it was a ten-minute revert and a footnote in the PR.[^2] The engine today is still partly Kotlin (`PropertyStore`, the prefilter, the optimized ontology), but only in the places where the benchmark said yes.

[^2]: Bonus episode from the same campaign: one optimization showed no improvement in the profile because, on closer inspection, the optimized method was never called. If your benchmark doesn't move, check that the thing you are benchmarking is the thing you are running.

{{< figure src="memory_after.png" alt="Memory allocations after the optimizations" caption="Memory allocations after the optimizations" >}}

## Running out of mistakes

The numbers, then. The workload that used to allocate over 30GB per day now stays under 3GB, and the GC sawtooth flattened out accordingly. That was the real win, and it shows where it matters: the dev machine has been stable since the patches landed, the restarts are gone, and the zombies with them. Speed is a humbler story. The benchmarks improved measurably, but the actual report generation is only marginally faster: what changed is that the runs are consistent now, because the heap no longer screams for help halfway through. In the last profiling session of the campaign, the top of the hot list was `StringBuilder.append`, all coming from the HTML report generation. I stared at it for a while and then closed the profiler: when the most expensive thing left is work that has to happen anyway, you are done.[^3]

[^3]: I did consider optimizing `StringBuilder.append` itself, for about a minute. Then I remembered I have a family. The curiosity survived though, and it's turning into a post of its own: coming soon, which is exactly what I always say.

The assistant, meanwhile, has already forgotten all of this. Next time we optimize something it will propose the idiomatic rewrite again, with total confidence. Luckily the `AGENTS.md` remembers for both of us, and it says: benchmark first.
