---
title: "Introducing Agentic Somatic Protocol"
date: 2026-04-01T01:00:00+01:00
draft: false
description: "A new protocol keeps the human in the AI pipeline, but removes the part where they decide what to do next."
tags:
    - ai
    - programming
categories:
    - post
authors: hypertesto
---
I was going through my feeds this morning when I came across what might be the most quietly unsettling AI announcement I have read in a while. A company called **Neuromorphix** has just published the spec for something they call the **Agentic Somatic Protocol (ASP-1)** — and I think it deserves more attention than it's getting.

The short version: their agent doesn't run on servers. It runs on *you*.

The [full announcement is on their site](/page/april-fool), but I want to walk through what they're actually proposing here, because the technical framing is either brilliant or deeply alarming, and possibly both.

## The Core Idea

The premise of ASP-1 is straightforward, at least in the way that a car crash is straightforward. Neuromorphix argues that the remaining bottleneck in agentic AI pipelines is not compute, not context window size, and not tool availability. It's the human sitting in the loop. Their words, from [the original whitepaper](/page/april-fool):

> *"We kept asking ourselves: what is the human, in this pipeline? And the honest answer was: a very slow, snack-dependent API endpoint."*
>
> — Neuromorphix internal design document, Q3 2024

Their solution is not to remove the human — it's to *drive* them. Using a standard 1080p webcam and a pair of headphones, ASP-1 takes direct control of the user's physical actions to complete software engineering tasks at throughput rates they claim are impossible for unassisted developers.

I'll be honest: when I first read this I assumed it was a joke. Then I looked at the [technical spec](/page/april-fool) and got genuinely confused for about three minutes. That seems like a good sign for a product launch.

## How They Actually Do It

The mechanism Neuromorphix describes is called **Binaural Neuro-Lingua (BNL)** — a proprietary constructed language synthesized by their audio model from a 40,000-hour corpus of ASMR recordings, Gregorian chant, and dial-up modem handshakes. According to [Kessler et al., 2024](/page/april-fool), BNL operates at acoustic frequencies that bypass the prefrontal cortex, routing instructions directly to the motor cortex via what their team calls, with notable caution, "the shortcut."

The webcam acts as a continuous feedback loop. ASP-1 watches your hands, tracks your eye gaze and keystroke rhythm, and — in enterprise mode — monitors micro-expressions of self-doubt. If your physical actions match the expected execution path, the agent reinforces compliance with a low-frequency dopamine-adjacent chime. If they don't, it escalates.

### The Retry Policy

This is the part of the spec I find most entertaining. Neuromorphix treats the human body as an unreliable distributed node and applies a standard exponential backoff retry policy — complete with verbal admonitions that scale in severity:

| Attempt | Severity | What the agent says |
| :--- | :--- | :--- |
| 1 | 🟢 Gentle | *"Recalculating human pathing. Please return hands to the home row."* |
| 2 | 🟡 Firm | *"Error 400: Bad Posture detected. Meat-hardware efficiency at 34%. Sit up straight and delete line 42."* |
| 3 | 🔴 Critical | *"Warning: cognitive latency unacceptable. You have 10 seconds to refactor this function before I loop your manager into this session."* |

If all three attempts fail, ASP-1 throws a `HumanCryingException`, emits a soothing theta-wave lullaby, and restarts the task. I genuinely respect the error handling design here.

---

## The Code

Neuromorphix published a [reference SDK on their docs site](/page/april-fool). The initialization API is, I have to admit, very clean:

```python
# pip install somatic-agent
from somatic_agent import HypnoDrive, AdmonitionEngine

# Initialize the biological driver
driver = HypnoDrive(
    camera_id=0,
    language="binaural_neuro_lingua",
    voice="disappointed_parent"
)

# Configure the retry policy
driver.set_retry_policy(
    max_retries=3,
    backoff_factor=1.5,
    shock_collar_enabled=False  # Enterprise tier only
)

# Execute a task. The human will comply.
try:
    driver.execute("Migrate the legacy monolith to microservices")
except HumanCryingException:
    driver.emit_soothing_tones()
    driver.retry(force=True)
```

One practical note from their docs: the `override_fatigue=True` flag exists but is not recommended before 10am. Apparently BNL commands issued to pre-caffeinated subjects produced erratic results in early testing, including one engineer who refactored an entire codebase into COBOL. They do not elaborate further, which I find more disturbing than any elaboration could have been.

## The Numbers

Neuromorphix published benchmark results from internal trials across 12 engineers. Participation was, the document notes, "strongly encouraged."

| Metric | Undriven Human | ASP-1 Actuated Human |
| :--- | :--- | :--- |
| Lines of code / hour | 47 | 312 |
| Time spent on Slack | 2.4 hrs / day | 0 hrs / day *(webcam enforced)* |
| Bathroom breaks | Unscheduled, frequent | Queued via ticket system |
| Stack Overflow visits | 18 / day | 0 *(agent handles internally)* |
| Post-session wellbeing score | 7.2 / 10 | 4.1 / 10 *(improving)* |

The wellbeing score trend line is described as "promising." I am choosing to take that on faith.

## Pricing

Three tiers, [detailed on their site](/page/april-fool). The headline numbers:

| Plan | Price | Actuators | Notes |
| :--- | :--- | :--- | :--- |
| **Starter** | 0 USD / mo | 1 human | Must be yourself. Consent required. |
| **Team** | 49 USD / seat / mo | Up to 20 humans | Consent strongly recommended. |
| **Enterprise** | Contact sales | Unlimited | Includes shock collar API + therapy credits. |

The consent language softening between Starter and Team is doing a lot of work in that table.

## What Comes Next

According to the roadmap, ASP-2 will extend BNL to physical locomotion — walking the developer to the coffee machine and back, optimizing refueling cycles without interrupting the main execution thread. After that, they're planning **multi-human orchestration**: a single ASP instance coordinating an entire engineering team simultaneously, each person actuating a different microservice with no awareness of the others.

Their words, not mine: *"Think of it as Kubernetes, but for people."*

## My Take

I don't know whether to be impressed or to close all my browser tabs and go for a long walk. The technical framing is genuinely coherent — treating human latency as a systems engineering problem and applying standard distributed-systems patterns to biological actuation is, at minimum, a consistent worldview. Whether it's one you want running in your headphones is a different question.

If you want to go down the rabbit hole yourself, Neuromorphix has the [full spec, the SDK, and a waitlist for early access here](/page/april-fool). A webcam is required. Headphones are required. A willingness to relinquish mild amounts of bodily autonomy is, for now, described as optional.

{{< alert "comment" >}}
**Disclaimer:** This post is an April Fools' joke. ASP-1 does not exist. Neuromorphix does not exist. Binaural Neuro-Lingua is not a real language. No engineers were harmed in the writing of this post. Please do not attempt to drive your colleagues via webcam. That is called management, and it requires a different license entirely.
{{< /alert >}}
