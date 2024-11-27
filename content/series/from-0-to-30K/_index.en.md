---
title: "From 0 to 30K: a theoretical journey of distributed systems through the lens of Star Citizen"
showTableOfContents: true
---

{{< figure src="cover.png" alt="cover" >}}

*"Using space games to understand distributed systems, or how I learned to stop worrying and love the 30k"*

It all began innocently enough with the [latest ISC](https://www.youtube.com/watch?v=Mgbgp4pRSJ4). One moment I was watching them talking about optimizing some
particular function and *that thing coming next patch[^a]*, there I was, flooding my org's Discord with rambles about
exponential distributions and network statistics. Because apparently analyzing network architectures of a game that
has already consumed more of my wallet than I'm willing to admit publicly is what I do for fun now - at least it's cheaper than buying another ship :money_with_wings:.

Turns out my org mates' polite suggestion to "maybe write this down somewhere" was actually a good idea.
Though I suspect they just wanted to reclaim the Discord channels from my impromptu statistics lectures and network performance rants.

## What's this all about?

Distributed systems are hard. So hard that most computer science books need hundreds of pages just to explain the basics.
Yet somehow, thousands of players manage to understand concepts like eventual consistency every day - they just call it
"that weird moment when my friend's ship was there but also wasn't there."

That's when it hit me: what better way to understand complex distributed systems than through the lens of space catastrophes?
After all, Star Citizen is basically a distributed systems playground where players unknowingly experience everything from
network partitions to Byzantine failures, usually while trying to land at Port Olisar (_press F to pay respects_) during a free fly week.

Think about it: every major distributed systems challenge is right there in the verse:

- Data consistency? Try explaining why your friend's ship appears in two places at once
- Race conditions? That awkward moment when two players try to grab the same piece of loot
- State synchronization? Ever seen a trolley achieve orbit because physics grids got confused
- Distributed consensus? Watch an org try to decide which server to join

And the best part? When these systems fail, we don't just get boring error logs - we get ships doing backflips in landing zones,
cargo that exists in a quantum superposition until observed, and physics grids that occasionally decide to interpret "gravity"
as more of a suggestion than a law.

That's what this series is about: taking complex computer science concepts and explaining them through Star Citizen scenarios.
Because nothing illustrates CAP theorem quite like watching half your fleet quantum jump to Pyro while the other half swears they're still in Stanton.

Each article comes with real code, actual math, and probably more charts than strictly necessary.
Because if I'm going to obsess over a space game's technical architecture, I might as well drag you all down this rabbit hole with me.

## Goals? We have those too!

Look, while ranting about network architectures and filling my org's Discord with statistical analyses is genuinely my idea of fun,
there's actually a method to this madness.

- First, we all need something to do while waiting for *that thing coming next patch[^a]* (Soon™). Sure, we could spend this time theory-crafting
about optimal fleet compositions or arguing about the best ship for solo play, but why not learn something while we wait?

- Second, distributed systems are fascinating, but they're often taught in the driest way possible. Nobody wants to read another
academic paper about Byzantine fault tolerance, but everyone understands the pain of watching their cargo ship quantum travel in
two directions at once. If we're going to spend hours in this verse, we might as well understand the technical chaos behind it.

- And finally, maybe, just maybe, we can help shift some conversations from "it's an easy fix" or "my cousin could code this better
in a weekend"[^0] to more interesting discussions about why these problems are actually challenging. Because while backseat game
development is a time-honored tradition, understanding why something is hard is far more fascinating than assuming it's easy.

## What to expect

Each article combines:

- Actual technical concepts (no handwaving here)
- Interactive Python notebooks to play with
- Real scenarios from the verse
- Mathematical foundations (where applicable)
- Enough sarcasm to fill a C2

Whether you're a developer curious about MMO infrastructure, a player wondering why certain technical limitations exist, or just someone interested in how complex distributed systems work,
these articles aim to explain the challenges through a lens we can all understand: things going wonderfully wrong in space.

*Because sometimes the best way to understand a complex system is to watch it fail spectacularly in space.*

[^0]: Or our very Italian way of saying this "*Il mio falegname con trentamile lire lo fa meglio"* (https://www.youtube.com/watch?v=gaOiKy3MRrA)
[^a]: Server Meshing
