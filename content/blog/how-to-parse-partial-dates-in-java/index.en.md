---
title: How to parse dates with optional parts with Java Instant API
date: 2024-01-03T17:03:45+01:00
draft: false
description: How to parse partial dates in Java with Instant API
tags:
    - Java
    - Kotlin
categories:
    - programming
---
Parsing partial dates can be a common challenge in Java programming, and Java 8's Instant API offers a powerful solution. 
In this article, we will explore how to effectively parse partial dates using Java 8's Instant API.

## Why (or not) parse partial dates?
Isn't parsing "full" dates enough of a headache?
Well, in a perfect world, we may handle only fully written dates and possibly in [ISO 8601](https://it.wikipedia.org/wiki/ISO_8601) but the reality is that neither users nor our data sources do it. Think about it: how many times did you require a user to fill, for example, its birthday with a precision up to a millisecond? I guess never [^0].

There are, of course, many ways to tackle this problem,
one of the easiest being storing the date information with the exact resolution you need,
so the omitted part becomes irrelevant.
That's why in the database world we have many ways to store date/time information; for example, let's check Postgres:

- `TIMESTAMP`: the standard timestamp (timezone is assumed to be UTC)
- `TIMESTAMPZ`: stores the timestamp along with timezone information
- `DATE`: only stores date (e.g. 2023-12-31)
- `TIME`: only stores time (e.g. 23:59.999)
- `TIMEZ`: only stores time along with timezone information

So, before over-complicating your parsing logic you should ask yourself: "Is the omitted part in the date/time I'm going to parse relevant? Should it be stored?"

## A more practical example
It wouldn't be a complete article if I didn't provide a real-world scenario that I implemented recently.

I was working on a CLI tool that along with other features, can query a database where there are two **timestamps** columns defined: `start_timestamp` and `end_timestamp` that are used to record when a job starts and ends.

The CLI has two arguments to filter over those two columns: `--from` and `--to` both of them accepting a date formatted as `yyyyMMdd[-HHmmss]`.  
Do you notice there's a part between square brackets? That's the optional part.

The idea of the optional part is that, without adding more arguments to the CLI, 
a user can query one or more full days if it provides the two arguments with only the mandatory part, 
or can go more fine-grained if needed (even mixing the formats).

To do it, we have two different argument semantics:
- `--from`: if omitted, the time part should be set to the start of the day which is "all zeroes" 
- `--to`: if omitted it should be set to the end of the day which is `23:59:59.999` (Here I haven't used the same format just for clarity)

## Different API, different defaults
Before getting to the actual code that solves our problem, let's write down some basic instructions to parse and print dates with Instant and the old Date APIs.

#### Old Date class
Execute this snippet:
```java
String rawDate = "20231231";
Date date = new SimpleDateFormat("yyyyMMdd").parse(rawDate);
```
it will output:
```java
Date is Sun Dec 31 00:00:00 CET 2023
```
The first thing to notice is that the old Date class is already defaulting to "all zeroes". 
The second thing is that the output is in `CET` timezone; this is machine-dependent.  
Also, notice there is no explicit "default" concept.

#### Instant class, attempt #1
Execute this snippet:
```java
String rawDate = "20231231";
Instant instant = DateTimeFormatter.ofPattern("yyyyMMdd").parse(rawDate, Instant::from);
```
it will give you an exception:
```
Text '20231231' could not be parsed: Unable to obtain Instant from TemporalAccessor: {},ISO resolved to 2023-12-31 of type java.time.format.Parsed
```
Why does it fail?  
Instant doesn't apply any default implicitly and the string `20231231` only contains information about a date. It doesn’t contain any information about the time of day. As such, there's no sufficient information to create an instance of the Instant class.

#### Instant class, attempt #2
Now that we know that Instant class wants the parser to explicitly declare defaults, let's execute this code:

```java
String rawDate = "20231231";
Instant instant = new DateTimeFormatterBuilder()
        .appendPattern("yyyyMMdd")
        .parseDefaulting(ChronoField.NANO_OF_DAY, 0)
        .toFormatter()
        .withZone(ZoneId.of("UTC"))
        .parse(rawDate, Instant::from);

System.out.println("Instant is " + instant);
```
This time it will give you the expected result:

```
Instant is 2023-12-31T00:00:00Z
```
Notice that:
- `parseDefaulting` takes a `ChronoField` and a value.  
In this example, I've hard-coded a `0`, but you should use some meaningful constant; I like to use [LocalTime](https://docs.oracle.com/javase/8/docs/api/java/time/LocalTime.html) for this.
- I also added an explicit timezone (UTC), try to omit it and compare the output (assuming you’re in a different timezone than UTC)

This is almost everything we need to finally parse dates with optional parts.

## Instant class with optional parts
With all the information that we have now, it's almost effortless:
all we need is to define the optional part in the pattern string and play with `parseDefaulting`.

That's what I've come up with to handle the different semantics of `--from` and `--to` in my use case:

```java
package com.hypertesto.example;

import java.text.ParseException;
import java.time.Instant;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;

public class InstantWithOptionalPartExample {

        public static void main(String[] args) throws ParseException {
        String rawPartialDate = "20231231";
        String rawFullDate = "20231231-121212";

        Instant partialFrom = parseFromArgument(rawPartialDate);
        Instant partialTo = parseToArgument(rawPartialDate);

        Instant fullFrom = parseFromArgument(rawFullDate);
        Instant fullTo = parseToArgument(rawFullDate);

        System.out.println("Partial 'from' argument is " + partialFrom);
        System.out.println("Partial 'to' argument is " + partialTo);

        System.out.println("Full 'from' argument is " + fullFrom);
        System.out.println("Full 'to' argument is " + fullTo);
    }

    public static Instant parseFromArgument(String string) {
        return parseDateWithOptionalPart(string, LocalTime.MIN);
    }

    public static Instant parseToArgument(String string) {
        return parseDateWithOptionalPart(string, LocalTime.MAX);
    }

    private static Instant parseDateWithOptionalPart(String string, LocalTime defaultTime) {
        return new DateTimeFormatterBuilder()
                .appendPattern("yyyyMMdd[-HHmmss]")
                .parseDefaulting(ChronoField.HOUR_OF_DAY, defaultTime.getHour())
                .parseDefaulting(ChronoField.MINUTE_OF_HOUR, defaultTime.getMinute())
                .parseDefaulting(ChronoField.SECOND_OF_MINUTE, defaultTime.getSecond())
                .parseDefaulting(ChronoField.NANO_OF_SECOND, defaultTime.getNano())
                .toFormatter()
                .withZone(ZoneId.of("UTC"))
                .parse(string, Instant::from);
    }
}
```

I've arranged this example class to be self-explaining, but if you have doubts leave a comment; I'll be happy to clarify!

This is its output:

```
Partial 'from' argument is 2023-12-31T00:00:00Z
Partial 'to' argument is 2023-12-31T23:59:59.999999999Z
Full 'from' argument is 2023-12-31T12:12:12Z
Full 'to' argument is 2023-12-31T12:12:12.999999999Z
```

## Conclusion
In conclusion, this article has briefly explored the utility and methodology of parsing partial dates using Java 8's Instant API.
Through practical examples, we've seen how parsing partial dates with Instant API is straightforward, provided we have a clean idea of how to handle defaults. 

Lastly, remember there isn't only Instant API in modern Java, in fact,
there are `LocalDateTime` and `ZonedDateTime`classes which are also fine for this kind of processing [^1].

I hope the article was useful to you, thanks for reading it!


[^0]: It would be impractical anyway, but I couldn't come up with a better example.
[^1]: Maybe better for my use case, but I had my reasons to stick with Instant class for that project.