---
title: "From 0 to 30K - Network"
aliases:
- /en/blog/2024/11/from-0-to-30k
date: 2024-11-17T18:56:31+01:00
draft: false
description: "A theoretical journey of distributed systems through the lens of Star Citizen"
categories:
- gaming
tags:
- star citizen
- networks
- simulations
series:
- From 0 to 30K
---
*"In space, no one can hear you lag" - unless you're in proximity chat, then everyone hears you rubber-band.*

Welcome to the first article in a series exploring computer science concepts through Star Citizen!
From network architecture to load balancing, from server coordinates to deadlocks - we'll be using
space mishaps to understand why distributed systems are both fascinating and terrifying.
Why Star Citizen? Because explaining distributed systems is hard, but everyone understands the pain of rubber-banding into an asteroid.

Ever wondered why sometimes your perfect shot misses, or why your ship rubber-bands during quantum travel?
Let's start with the network basics behind these daily space dramas. I'll be using Python to visualize
these concepts, because if there's one thing I love more than filling Hercules with trolleys, it's turning data into charts.


Fair warning: like CIG's release dates, all numbers in this article are subject to change and should be taken with enough salt to fill a Starfarer.
The goal here isn't to provide exact figures, but to understand the underlying concepts that make our space shenanigans possible
(or occasionally impossible, looking at you, 30k).

All code examples in this article are available in [this Python notebook](https://colab.research.google.com/drive/1_h8U6oKOA1FK8tjzksca3Ex4kBUco1Yo?usp=sharing).
Feel free to experiment with the numbers - breaking things is how we learn!

## Understanding Network Basics

Before we quantum travel into the deep analysis, let's understand some key concepts that affect your journey through the verse.

A quick note about the math: in our analysis, we'll be using two main types of statistical distributions to model network behavior:

- **Normal distribution** (also called Gaussian) for typical network conditions - think of your regular quantum travel, where most jumps take about the same time with small variations
- **Exponential distribution** for modeling network issues - like those rare but dramatic moments when your ship decides interpretive dance is its true calling. It gives us lots of normal values but allows for those occasional dramatic spikes

These aren't just arbitrary choices - they're commonly used in real network analysis because they match what we actually see in practice.
The normal distribution is perfect for modeling stable connections with small variations, while the exponential distribution captures those
"rare but significant" events that make space life interesting.

Now, let's dive into the specific metrics that determine whether your perfect shot lands or your ship decides to cosplay as a pinwheel...

### RTT (Round Trip Time)

Round Trip Time measures how long it takes for a signal to make a complete journey. In Star Citizen terms:

1. You press the trigger (signal to server)
2. Server processes the shot
3. Server sends back the result
4. Your client shows the hit/miss

```python
# Example from our notebook
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Simulate RTT measurements
good_connection = np.random.normal(50, 5, 1000)  # Mean 50ms, SD 5ms
poor_connection = np.random.normal(200, 30, 1000)  # Mean 200ms, SD 30ms

# Plot RTT distribution
plt.figure(figsize=(10, 6))
sns.kdeplot(good_connection, label='Good Connection')
sns.kdeplot(poor_connection, label='Poor Connection')
plt.xlabel('RTT (ms)')
plt.title('RTT Distribution: Good vs Poor Connection')
plt.legend()
```

This directly affects your gameplay:
- Low RTT (~50ms): Your shots feel responsive
- Medium RTT (~150ms): Slight delay but playable
- High RTT (300ms+): Noticeable lag in all actions

### Jitter: the turbulence factor

Notice how the "Poor Connection" had a much wider spread than the "Good Connection" - that's jitter in action. While RTT tells you the average delay, jitter (measured as standard deviation) shows how stable that delay is. It's like comparing:

- Low jitter (SD ~5ms): Like the tight distribution in our "Good Connection" - smooth quantum travel
- High jitter (SD ~30ms): Like the wide spread in our "Poor Connection" - bumpy atmospheric flight

```python
# Simulate different jitter scenarios
stable = np.random.normal(100, 5, 100)  # Stable connection
unstable = np.random.normal(100, 30, 100)  # Unstable connection

# Plot time series
plt.figure(figsize=(12, 6))
plt.plot(stable, label='Stable (Low Jitter)')
plt.plot(unstable, label='Unstable (High Jitter)')
plt.xlabel('Packet Number')
plt.ylabel('Latency (ms)')
plt.title('Impact of Jitter on Connection Stability')
plt.legend()
```

### Percentiles: beyond the average

Averages can be misleading. Percentiles give us a better picture:

```python
# Generate realistic game session data
session_data = np.random.exponential(50, 1000)

# Calculate key percentiles
p50 = np.percentile(session_data, 50)  # Median experience
p95 = np.percentile(session_data, 95)  # Occasional spikes
p99 = np.percentile(session_data, 99)  # Rare but severe issues

# Visualize with markers for percentiles
plt.figure(figsize=(12, 6))
sns.histplot(session_data, bins=50)
plt.axvline(p50, color='g', linestyle='--', label='P50 (Median)')
plt.axvline(p95, color='y', linestyle='--', label='P95')
plt.axvline(p99, color='r', linestyle='--', label='P99')
plt.title('Network Performance Distribution')
plt.xlabel('Latency (ms)')
plt.legend()
```

This helps explain why:
- Your average ping might look fine, but you still experience occasional issues
- Some players have different experiences with similar average connections
- Network problems often feel worse than the numbers suggest

### Bandwidth

*"How much bandwidth do you need? Yes." - CIG Server Engineer, probably*

While modern internet connections usually handle client bandwidth needs just fine, it's worth thinking about the bigger picture. Your client might only need to send and receive data about nearby ships, but imagine being the server:

```python
# Simulate server bandwidth requirements
def calculate_server_bandwidth(num_players, data_per_player=1000):  # 1KB per player
    total_bandwidth = 0
    # Each player needs updates about other nearby players
    for player in range(num_players):
        nearby_players = min(num_players - 1, 50)  # Assume max 50 relevant players
        total_bandwidth += nearby_players * data_per_player
    return total_bandwidth / (1024 * 1024)  # Convert to MB/s

players = range(10, 501, 10)
bandwidth = [calculate_server_bandwidth(n) for n in players]

plt.figure(figsize=(10, 6))
plt.plot(players, bandwidth)
plt.title('Server Bandwidth vs Player Count')
plt.xlabel('Number of Players')
plt.ylabel('Bandwidth Required (MB/s)')
plt.grid(True)
```

Hipotetical bandwidth requirements:
- You visiting Port Olisar: ~100KB/s
- You during combat: ~300KB/s
- Server handling Port Olisar during free fly week: *nervous server noises*

Think about it: every time someone spawns their shiny new 890 Jump (and we know there's always someone spawning an 890), the server needs to tell everyone nearby about each of its 12,937 polygons and that one coffee cup that's about to achieve orbit.

### Real-World Impact on Gameplay

Let's see how these metrics affect different activities:

```python
# Simulate different gameplay scenarios
def simulate_gameplay(rtt, jitter, activity_threshold):
    samples = np.random.normal(rtt, jitter, 1000)
    reliability = np.mean(samples < activity_threshold)
    return reliability

activities = {
    'Mining': 200,  # More latency tolerant
    'Trading': 150,  # Medium sensitivity
    'Combat': 100   # Highly sensitive
}

results = {activity: simulate_gameplay(100, 20, threshold)
          for activity, threshold in activities.items()}

# Visualize activity reliability
plt.figure(figsize=(10, 6))
plt.bar(results.keys(), results.values())
plt.title('Network Impact on Different Activities')
plt.ylabel('Reliability Score')
```

Let's see how these network metrics affect different activities:
- Mining: Like dating - timing is important but a little delay won't kill you
- Trading: Similar to your ship's insurance expiration - you have some wiggle room
- Combat: As precise as explaining to your org why you "borrowed" their Carrack

## So what have we learned this week?

Networking isn't just about having a fast internet connection - it's a complex dance of RTT, jitter, bandwidth, and percentiles that all work together to determine whether your perfect shot lands or your ship decides to practice interpretive dance during quantum travel.

By analyzing the data and visualizations, we can see why:

- Using averages for network performance is like measuring a quantum drive's efficiency by counting wake turbulence - technically possible but missing the point
- The P95/P99 metrics explain those "I SWEAR I hit them!" moments better than any conspiracy about CIG's hit detection
- Your friend's "perfect" 50ms connection might actually perform worse than your "stable" 100ms one when jitter enters the chat

And perhaps most importantly, we've learned that somewhere out there, a server is doing complex bandwidth calculations to figure out how to tell everyone about that one player who decided to fill their C2 with `1E+2` trolleys (because apparently regular notation isn't enough to express this level of abuse).
