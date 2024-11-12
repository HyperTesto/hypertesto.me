---
title: "P100Y of ISO-litude: a Duration's tale of acceptance"
date: 2024-11-12T21:58:39+01:00
draft: false
tags: "kotlin"
categories: "kotlin"
authors: "hypertesto"
---
If you've been following this blog, you might have noticed I have a thing for Kotlin's `Duration` class. I've written about it before, and the more I use it, the more I appreciate how it manages to be both technically sophisticated and developer-friendly.

Today's story started when a unit test caught something interesting: the same duration string "1.5s" would work perfectly with `Duration.parse()` but fail during JSON deserialization with real world data.

What looked like inconsistent behavior taught me a lesson: `Duration.parse()` is flexible by design, `kotlinx.serialization` strict by choice.

## What's happening under the hood?
Looking at Kotlin's actual source code reveals an interesting story. First, let's look at Duration itself:

```kotlin
// In Duration.kt
public inline class Duration internal constructor(
    private val rawValue: Long
) : Comparable<Duration> {
    // ...
    companion object {

        public fun parse(value: String): Duration = try {
            parseDuration(value, strictIso = false)
        } catch (e: IllegalArgumentException) {
            throw IllegalArgumentException(
                "Invalid duration string format: '$value'.", e
            )
        }
    }
}
```

A few interesting things to note here:

- Duration is an inline class with an internal constructor
- The constructor couldn't be used for deserialization anyway due to its visibility
- The `parse()` method intentionally accepts non-ISO formats with `strictIso = false`

Now, let's look at how `kotlinx.serialization` handles Duration:

```kotlin
internal object DurationSerializer : KSerializer<Duration> {
    override val descriptor: SerialDescriptor =
        PrimitiveSerialDescriptor("kotlin.time.Duration", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: Duration) {
        encoder.encodeString(value.toIsoString())
    }

    override fun deserialize(decoder: Decoder): Duration {
        return Duration.parseIsoString(decoder.decodeString())
    }
}
```

This is where it gets interesting - the serializer makes a deliberate choice to use `parseIsoString()` for deserialization, while it could have used the more permissive `parse()`.

## When you can't fire the bouncer, open a side door

Since we can't change kotlinx.serialization's built-in behavior (and perhaps we shouldn't - there are good reasons for enforcing standards in serialization),
we can create our own more lenient serializer:

```kotlin
internal object LenientDurationSerializer : KSerializer<Duration> {
    override val descriptor: SerialDescriptor =
        PrimitiveSerialDescriptor("kotlin.time.Duration", PrimitiveKind.STRING)

    override fun deserialize(decoder: Decoder): Duration {
        return Duration.parse(decoder.decodeString())  // Using the lenient parser
    }

    override fun serialize(encoder: Encoder, value: Duration) {
        encoder.encodeString(value.toIsoString())  // Still formal in output using ISO
    }
}
```

This serializer acts like a diplomatic translator: it accepts casual format in input (using `parse()`) but ensures formal ISO-8601 format in output (using `toIsoString()`).

Apply it to your data classes like this:

```kotlin
data class ProcessDuration(
    @Serializable(with = LenientDurationSerializer::class)
    val duration: Duration
)

// Now both these work:
val formal = """{"duration": "PT1.5S"}"""
val casual = """{"duration": "1.5s"}"""
```

This approach implements a fundamental principle of data exchange. Watch how our duration gets standardized during serialization:
```kotlin
// What goes in
{"duration": "1s"}

// What comes out
{"duration": "PT1S"}
```

They represent the same duration, just dressed differently. Like changing into formal attire for an evening event - same person, different presentation.
And this is exactly what we want: when writing data that might be consumed by other systems, enforcing a standard format isn't just being pedantic - it's being a good citizen of the ecosystem.
Our parser can be flexible in what it accepts, but should be strict in what it produces.

## Standards vs reality: a pragmatic approach
Let's be honest here: while enforcing ISO-8601 in serialization is technically correct (the best kind of correct!), the real world is messier. Much messier.
Anyone who has dealt with dates, time, and durations in production knows the chaos. You might encounter:

- Timestamps like "Last Monday" (thanks, natural language processing team!)
- Timezones as "GMT+1" or "UTC+1" or "+0100" or "Europe/Paris" or just "1" (pick one, they said... no, not that one!)
- Dates coming from that legacy system as "23-11-2023"... no wait, "11-23-2023"... actually "2023/11/23" (depends on which server you hit)
- Durations like "two_and_a_half_hours" (because someone really hates numbers)
- "5400000ms" (hello Java, is that you?)
- "P0Y0M0DT1H30M0S" (someone REALLY liked XML back in 2003)
- That one API that sends timestamps as Facebook likes count since the epoch (because why not?)

The Wild West of time formats is real, and it's not going anywhere.
While standards like ISO-8601 are crucial for reliable data exchange, being too rigid can backfire.
Sometimes we need to be pragmatic and meet the data where it is, not where we wish it was.

## The moral of our story
What started as a surprising test failure led me to appreciate the thoughtful design behind Kotlin's Duration.
Like the protagonist in our ISO-litude tale, I learned that acceptance follows different paths: Duration's `parse()` method welcomes various formats for developer convenience, while `kotlinx.serialization` enforces ISO standards for data exchange.
In this story of formats and parsing, there's no solitude at all - just a well-designed ecosystem where each component knows its role.
