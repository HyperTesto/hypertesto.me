---
title: "Asset flips and vibes: fifteen years of videogames as a preview of the LLM era"
date: 2026-10-18T12:30:00+02:00
draft: false
description: "Game engines democratized development and Steam filled up with hype-first asset flips. LLMs are doing the same to all of software, faster."
tags:
  - llm
  - AI
  - gamedev
  - videogames
  - software development
  - opinion
categories:
  - post
  - gaming
authors:
  - hypertesto
---

Over the last couple of years my reading list has been colonized by a single genre: the AI-assisted coding essay. I've read excellent specimens in every direction:
- converts describing the first time an agent refactored a whole module while they made coffee, half a religious experience;
- burned veterans who tried the same trick and lost an afternoon reviewing code that was *almost* right, which is the most expensive kind of wrong;
- and a few serene souls in the middle, calmly weighing pros and cons with an equilibrium I envy and cannot reproduce.[^1]

[^1]: If you wrote one of those posts and you recognize yourself: share your post in the comments section!

I kept postponing my own take on all of this, because everything sensible seemed already written and I'm not enough an expert in this field for my voice to be somehow worth listening to. And then I realized the angle I was looking for had been sitting in a different part of my hard drive the whole time: *my Steam library*.

## The graveyard in my library 

I have a small graveyard in my Steam library. It's the shelf where Early Access games go to receive two patches, a roadmap full of promises, and then eternal silence. The latest entry is a survival crafting game I bought because the trailer looked great and the description used the word "emergent" three times. It emerged, all right: it emerged that the models, the animations and half the interface came from an asset store, and the only original component was the crash reporter.

I think about that graveyard more than I should. I started thinking about it during the post-Covid period, when a friend and I kept hitting the same wall in every early access alpha we tried. That friend is Devorath, a veteran in every sense: we survived Foxhole together, which is the kind of shared trauma that bonds people for life.[^2a] We had a rotation going:

- New World, where I spent more hours in queue than in the game
- Myth of Empires, _which we don't talk about_.[^2b]
- Pax Dei, which looked promising until it didn't. 

Each time the pattern was the same: a trailer that looked like the future of the genre, a feature list that read like a Christmas wish list, and then well... _bleah_.

[^2a]: Foxhole is a top-down persistent war game where hundreds of players manually logistics-supply a frontline for weeks on end. It is the most fun you can have while doing something that would, in any other context, be considered work.

[^2b]: We really don't. Ask me in the comments if you must, but I warn you: the answer involves grief.

The connection to what I do for a living took me a while to see, and now I can't unsee it. The story of those games is the story of one of the best things that happened to videogames, and at the same time the story of what is happening to our whole industry right now.

## Everyone's a game developer now

Around the turn of the 2010s, the walls came down. Unity went free, Unreal followed, GameMaker and RPG Maker kept the door open for the 2D crowd, and Steam first opened Greenlight and then removed the gate altogether. A laptop and some patience were suddenly enough to put a game on the largest storefront on the planet, in front of millions of people, with nobody's permission required.

I want to be precise here, because this part matters: **the democratization was wonderful**. It gave us one-person labors of love like Stardew Valley, oddities like Undertale, entire genres that exist because somebody could sit down and make them. I refuse to live in a timeline where Vampire Survivors had to pitch itself to a publisher before existing.[^3a]

[^3a]: And before the TVA shows up to prune this one, I mean it. Sacred Timeline stuff. Don't @ me, Loki.

Making a game required more than tools, though. It required the kind of things you can't download: dedication, real knowledge of the domain you were simulating, the patience to iterate on level design until it felt right, an ear for dialogue, a sense of pacing, the ability to write characters you'd actually remember a decade later. None of that came in the box with Unity. You either brought it yourself or you didn't, and the games that still get talked about today are the ones where somebody clearly did.

On top of all of this there's one last thing that separates the games that survive from the ones that get delisted and forgotten, and it's the most unmeasurable of the lot: **the love for the craft**.[^3b] It's the quality that makes you boot up a game from 2003 and realize the people who made it cared that the grain prices in Lübeck responded correctly to a bad harvest up the coast. You can't patch it in, you can't buy it from a store, and no engine in the world will ever hand it to you for free.

[^3b]: I know how this sounds. I sound like a boiled-down version of an old developer on a forum. I stand by it anyway.

{{< figure
  src="patrician3.en.jpg"
  alt="Patrician III"
  caption="Exhibit A: Patrician III, a Hanseatic trading sim released in 2003 by Ascaron, a small German studio that has been gone for years. Two decades later it still beats the ass of most modern games in its own genre: the economy simulation holds up, the design is tight, and the people who built it were annoyingly skilled at turning good ideas into systems that work. Ascaron went bankrupt in 2009, which in hindsight feels like an omen for this entire post."
>}}

And yet the same open gate that let Stardew Valley through also let in what the community learned to call *asset flips*: products assembled from store-bought models and tutorial code, wrapped in a trailer cut to look like the next big thing. The tools multiplied the number of developers by a thousand; they did nothing to multiply the skills. This is where the pattern I keep seeing begins: **making became easy, promising started paying better than delivering**.

## When the promise becomes the product

There's an economy of attention that kicks in whenever a craft gets democratized, and videogames spent fifteen years mapping it: *if anyone can ship, shipping stops impressing anyone, and attention becomes the thing worth fighting for*.  
The cheapest way to get attention is to claim something enormous, so that's what happened: Kickstarter campaigns that promised to redefine genres and delivered demos, trailers labeled "in-engine footage" (an expression I cherish, because it's technically true and spiritually false), No Man's Sky shipping in 2016 with a feature list that lived mostly in interviews, Cyberpunk 2077 running on last-gen consoles the way I run on Monday mornings. And then there's Star Citizen, which sold so many dreams that it now has a war chest on par with the GDP of a micro-nation.[^4]

[^4]: At the time of writing the campaign has raised $1,055,690,873, and the release date remains a philosophical concept. I say this with love: I own ~~a JPEG of~~ a ship in that game... Okay, maybe *some* ships... Okay, okay... I *accidentally* became a concierge.

{{< alert "comment" >}}
I'm aware I picked examples that, for the most part, eventually redeemed themselves over the years. I did it on purpose: I wanted titles anyone who hasn't spent the last fifteen years in a cave would recognize, rather than some obscure indie that nobody knows.
{{< /alert >}}

The claims grew more grandiose exactly as the products grew thinner, and I don't think that's a coincidence or a moral failing of individual developers. It's a structural effect: the engine handles memory, physics, netcode and rendering, the tutorial handles the rest. You can operate all of it without any of the fundamentals of computer science, and nothing forces you to notice until the game has to do something the tutorial didn't cover: save files that corrupt themselves, multiplayer that desyncs when a second player joins, performance that melts as soon as thirty enemies are on screen, a day-one patch that fixes one bug and introduces three.

The trailer, meanwhile, is ready months in advance, because cutting a trailer doesn't require knowing what a memory leak is. Hype lives in the gap between what you can promise and what you can actually build, and that gap has never been wider.

---

## Same old tricks

I watched all of this as a player, mildly annoyed. Then LLMs arrived, and I realized I had seen this film before.

What happened to game development across fifteen years is a subset of what the whole software industry is living through in a handful of them. The barrier to producing code has fallen through the floor: you describe an app, a model writes it, and if your quality bar is *"it compiles and the happy path works"*, you can have something on the internet by dinner. The software equivalent of the asset flip already exists and thrives: the SaaS launched over a weekend, the landing page with the revenue screenshot, the product that under scrutiny turns out to be a system prompt and a prayer.[^5]

[^5]: The screenshot is always the Stripe revenue graph. The refund graph is never shown.

{{< figure
  src="makenomistakes.en.webp"
  alt="Make no mistakes meme"
  caption="Claude, build a flawless Web3 AI SaaS platform before my VC meeting in 20 minutes. No placeholders or // TODO tags. Make no mistakes."
>}}

And the claims inflated accordingly, following the same structural logic, with one escalation: **the boldest ones now come from the tool makers themselves**. In gaming the promise was *"a universe you can live in"*. Now it's artificial general intelligence within a year, give or take, and entire professions, mine included, declared replaceable within six months, on a cadence that repeats roughly every six months.[^6] The ratio of claim to deliverable feels familiar because I spent fifteen years calibrating that exact instrument on Steam store pages.

[^6]: As I write this, the estimated arrival of my professional obsolescence is next spring. It was also next spring in 2023. The date moves, the season doesn't.

Before it sounds like I'm dunking on everyone in the space, let me be explicit about who I respect in it: the people building actual products on top of frontier models and managing to estimate their expenses correctly. Think about what that job involves. Your main cost of goods is a metered, nondeterministic service, priced per token, whose price list, behavior and availability can shift on somebody else's quarterly roadmap, while your users do whatever they feel like doing. Making margins work there takes real knowledge and a nerve of steel, and I find the combination fascinating.[^7]

[^7]: I'm serious. It's like pricing a restaurant menu while your supplier can change the price, the quality and the very definition of "ingredient" between lunch and dinner.

## The idea and its body

There's a premise I'm on board with: in software, the idea matters more than the implementation. **A mediocre implementation of a great idea beats a flawless implementation of nothing**, and history is full of brilliant codebases that solved problems nobody had.

I know how that sounds in a field where marketing now reigns, where the launch page matters more than the product page and the trailer matters more than the game. I'm not arguing against that reality, I'm arguing past it: hype sells the first copy, the idea is what sells the second million, and nothing sells the hundredth copy if the idea underneath was hollow to begin with.

I arrived at this premise late, though, and guilty as charged: it's the opposite of what most of us absorb during our studies and the first years of a career, where the implementation is the whole exam and the idea is somebody else's problem. I spent a non-trivial share of my early years polishing the internals of things nobody needed, and I was proud of the polish.

The twist the LLM era adds is subtle and a bit cruel. Implementation has become cheap, but only its visible part: the first eighty percent, the one that demos well and fits in a screen recording. The rest (edge cases, security, data integrity, the user who does exactly the one thing you didn't expect) still costs what it always cost, and it still demands the same unfashionable equipment: method, a bit of theory, the patience to read code critically, including code you didn't write.

This is where the premise gets harder to apply, in a way that took me some time to articulate. The premise still holds, but only when there's enough signal to tell a great idea from a mediocre one.  
An idea, outside your head, only exists through its realization: nobody will ever interact with your concept, they interact with the thing you built. When the implementation is thin enough, the idea doesn't get a fair trial, because there isn't enough of it left to judge. The asset flip didn't fail because assembling other people's assets was shameful, plenty of decent games do it. It failed because there was no game underneath, and no trailer could fix that.   

The pattern wasn't *great idea, botched execution*. The pattern was *no idea, botched execution*, and the trailer was there to make sure you didn't notice.

I've already watched the software version happen: a product that under the landing page had nothing but vibes and a system prompt, vibe-coded into existence in a week, dead within months because the first real users found the holes that one afternoon of code review would have caught. The landing page was beautiful, by the way: colorful, polished, and vaguely identical to the other gazillion AI-generated landing pages out there.

## What stays scarce

If there's a thought I keep coming back to, it's that every democratization redistributes scarcity. Cheap cameras turned everyone into a photographer, and what stayed rare was the eye. Game engines moved the bottleneck to design. With LLMs turning everyone into a programmer, my bet is that the scarce thing this time is judgment: knowing what correct looks like, sensing where a system will break, deciding which parts of the machine's output deserve your trust.

And behind judgment there's a second scarcity, even less glamorous: time. A model can produce code far faster than any team can read it, so an AI-assisted project can quietly grow past the human capacity to judge what it contains. At that point the codebase is yours the way the national debt is yours.

Nor is the scarcity only human: the physical layer is feeling it too. RAM prices are climbing at the speed of light, with datacenters eating the DRAM supply by the shipload. GPUs, when you can find them, get allocated before they physically exist. And the shared infrastructure we all stand on is creaking in public: GitHub's status page has collected more red in recent months than a roulette table.[^8]

[^8]: If you haven't looked at the incident numbers recently, go look. I'll wait.

{{< figure
  src="github-down.en.jpeg"
  alt="Github down meme"
  caption="I am a caption ;-)"
>}}

Keeping up with all of this, meanwhile, has become its own part-time job. I used to think nothing could outgrow the JavaScript ecosystem, where a new framework sprouts every time someone waters a React app. Then the LLM space arrived and the mushrooms learned to spore: my reading queue now holds papers, model announcements, six agents, four frameworks for orchestrating agents, and a guide to choosing between the four frameworks, and I strongly suspect it breeds when I'm not watching.

For a while I did find this depressing. There was a stretch, somewhere between the third *"AI will replace you in six months"* headline and the fifth SaaS-shaped asset flip in my feed, where the whole thing just made me tired. I caught myself doing the boomer bit, the one where you sit in front of a screen and quietly wonder whether you spent your twenties learning a trade that's about to be automated into a vibe. It's not a flattering look, and it doesn't help that it's exactly the look the people selling the revolution want you to have.[^9]

[^9]: Fear is a feature, not a bug, when the product is a subscription.

I don't find it depressing anymore, though. The gems of the engine era came from people who couldn't ship before and suddenly could, and the same will happen now; the slop will arrive in much larger volume, because slop was always a volume business. What changed is where the craft sits. Producing code stopped being the bottleneck, so the work moved upstream: into reading code you didn't write, reviewing it, doubting it at the right moments, knowing when to trust the machine and when to throw its output away.

And if you're wondering where the love for the craft went, the thing I was so sentimental about a few paragraphs ago with the grain prices in Lübeck, I think it went upstream too. **The love used to live in what you put in, now it lives in what you refuse to let through**. It's the patience to read a diff you didn't write because shipping it unread would feel wrong, the refusal to call a feature done because the model said it was, the willingness to say *"no, this shit is broken"* when the demo already looks great and nobody else would notice. It's less romantic than simulating a Hanseatic port, I'll give you that. But it's the same instinct, pointing at a different part of the machine.

## Notes from the shower

I'm aware that none of this proves anything, and I'm not trying to. This post is the written version of a thought I kept having in the shower, or on a walk, or in the queue for another Pax Dei login, that wouldn't leave me alone until I typed it out. If you want a thesis with citations and a survey sample, I'm the wrong author and this is the wrong blog. What you get here is a pattern I couldn't stop noticing, written down in the hope that doing so would make it stop loitering in my head.[^10]

[^10]: Spoiler: it didn't, I'm already drafting the next one.

What I can tell you is that I spent fifteen years watching one industry go through this exact cycle, and now I'm watching my own do it on fast-forward, and the pattern matches. Maybe that's confirmation bias, but maybe the distinction matters less than the fact that I can't stop seeing it. At some point you either write the thing down or you keep boring your friends about it; and my friend Devorath has suffered enough.
