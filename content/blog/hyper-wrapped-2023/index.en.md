---
title: Hyper Wrapped 2023
description: My 2023 in nerd terms
date: 2023-12-29T20:48:33.168Z
draft: false
tags:
    - "2023"
    - hyperwrapped
categories:
    - swag
authors: hypertesto
---
2023 has been a challenging [^0] year both from a personal and professional perspective, but at least I can say **"I held the line"**[^1]. Surviving in this world of wars, pandemics, security breaches and [crazy ass moments in Italian politics](https://twitter.com/CrazyItalianPol) ain't an easy task.  

I promise I will keep the article less on my personal affairs and more on interesting nerd stuff; happy reading!

## The ChangeBlog[^2]
Besides the usual assortment of updates to Hugo and the theme, I've removed most [indieweb](https://indieweb.org/) microformat stuff because it was becoming hard to keep my local hacks to the theme in sync with upstream.

I also experimented a bit on [ActivityPub](https://it.wikipedia.org/wiki/ActivityPub), but it's not so easy to implement on a static-generated website like this; at least not without relying on sorceries and hacky stuff. For now, I won't dig further into this.

Content side, I've opened the [English section](/en)! (otherwise you wouldn't be reading this in English). I even wrote some articles during the year! I plan to gradually "deprecate" Italian for technical articles and write more in English. But fear not: I'll stick with Italian where it makes sense!

I also replaced Hyvor Talk (which I covered in [this article](/10-1-valide-alternative-a-disqus)) because I had issues with the new version 3 and honestly it was an overkill for a blog like mine. So I self-hosted [Remark42](https://remark42.com/) which is fine for my needs and also has a Telegram integration!
I migrated the comments manually, it was faster than doing an automation for like 20 entries.

The revision of the comment section gave me the chance to play with [Scaleway TEM](https://www.scaleway.com/en/transactional-email-tem/) for transactional emails and rewrite my [privacy policy](/page/privacy). I'm very satisfied with the result.

Lastly, but not without being proud of myself, [**I've finally started my newsletter**](https://buttondown.email/hypertesto).  
The newsletter is intended for an Italian audience because it will be more personal and will touch stuff that otherwise I would have difficulty translating.  
The first one is about the infamous Italian bureaucracy that got my nerves during the year. If you are a person who is susceptible to certain themes, it will hurt - A LOT - you have been warned.

## Threads
If you are reading my blog, I'm pretty sure I'm not saying anything new speaking about the "newborn" social media by our friendly neighbor Mark: Threads.  
Newborn is in quotes because technically it launched on 4th July, but here in Europe it became available on 14th December after having won a battle (but not the war) against our stricter privacy rules (GDPR) and the Digital Markets Act (DMA)[^3].

{{< figure src="follow4follow.jpg" title="follow4follow" caption="How to get followers on Threads - 101" >}}

If you follow me on some social, I'm sure you noticed that I'm not very active, so why did I need another one in the first place? Well... because X<sup>formerly Twitter</sup> became a mess and Threads looks very promising [^4] despite my privacy concerns.  

I won't close my X<sup>formerly Twitter</sup> account like many already did, but I will keep it just to passively follow my "tech bubble" which is super interesting and still hasn't migrated elsewhere (the Fediverse).

At the moment, I am getting some followers, not that fast but faster than on X<sup>formerly Twitter</sup>.

Oh... I was forgetting the killer feature of the killer features: voice notes. It's so relaxing to listen to **burps and blasphemies in reply to our prime minister and other politicians**.

## I am part of the Proton family
I was past due on this matter; I have postponed it since 2021. It was time to gradually loosen my dependency on Google services and Proton was my final (and only) choice considering my privacy concerns.

Proton is a Swiss company that is recognized globally for its commitment to privacy and they proven to have a very deep understanding of cryptography. It will sound dumb to say, but not every wannabe security/privacy company gets cryptography right.

I went all in for the unlimited plan that gives me:
- 15 email accounts spread among three domains
- "hide-my-email" aliases that I will gradually start to use to catch who's sending marketing emails even if I choose not to
- 25 calendars
- Proton Drive with 500GB total space (shared with email)
- 10 high-speed VPNs
- Proton pass (I have plans to migrate from BitWarden but it will take some time)

I am not using every feature to 100% of its potential, but they are there in case I need them (and I'm sure I will). 7.99 €/month is a reasonable price to me.

## Kotlin
And now let's move to a programming topic: Kotlin.
During this year I was finally able to carve out time for getting back on track with Kotlin updates.

Kotlin's latest version is 1.9, which is also the last one before 2.0 that will introduce the new compiler frontend. 2.0 is not intended to be a breaking release like it would in a perfect semantic versioning scheme, but they choose to go this path since the new compiler frontend is a very big update.

While digging into the changelog from 1.1 and 1.6 (the two most used where I work), I learned some nice [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) that is *no-pain-involved* to apply with automatic refactor (if you keep your IntelliJ updated).

Migrating a dozen projects with a mixture of Kotlin versions ranging from 1.1 to 1.6 to a common version (in my case 1.9) was an easy task. I can't stress enough how they got it right at JetBrains: Kotlin is a fantastic language to work with, not only speaking of syntax but also tooling.  
The only thing that gave me some headache was Gradle which is changing so much stuff every minor release :-).

I can't leave you without a dedicated video on the state of Kotlin:

{{< youtube fWu39EOZhto >}}

### How to not measure durations
While reading Kotlin docs, I also learned two new things: 
- [Monotonic](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.time/-time-source/-monotonic/) class
- I measured durations the wrong way for all my life :-)

Learning about monotonic time sources wasn't hard since It's very intuitive if you remember some basic algebra. 
But let's get back to why I wasn't measuring durations correctly.  
Have you ever used a snippet like this?

```kotlin
val start = System.currentTimeMills()
// stuff
val duration = System.currentTimeMillis() - start
```
Yes? Then you fell into the trap: `System.currentTimeMillis()` uses the system clock, and hence is not [monotonic](https://en.wikipedia.org/wiki/Monotonic_function). You are not guaranteed that two consecutive calls to it return two *strictly increasing*[^5] numbers (the function returns a Long), so the resulting duration could be negative.  

The term "strictly increasing" has a specific meaning in algebra:  
{{< katex >}}
> A function \\(f(x)\\) is said to be strictly increasing on an interval \\(I\\) if \\(f(b)>f(a)\\) for all \\(b>a\\), where \\(a,b \in I\\). On the other hand, if \\(f(b)>=f(a)\\) for all \\(b>a\\), the function is said to be (nonstrictly) increasing.

Still not sure why the system clock is not monotonic? It can be altered by: the user manually setting it, DST savings, automatic adjustments from Network Time Protocol (NTP) and many more.

So how to measure durations the right way? Kotlin got us covered with the practical and elegant monotonic function [`measureTime`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.time/measure-time.html) which is very easy to use:

```kotlin
val duration = measureTime {
    // stuff
}
```
Very *kotlinesque* and you have the variant [`measureTimedValue`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.time/measure-timed-value.html) that also returns a value on which you can use decomposition to save the value and the duration 🚀.

## Java
Working with Kotlin is impossible without touching some Java code, so I invested some time to learn something new here too:
- changes from version 8 to version 21
- Instant API

Java has evolved significantly from Java 8 to Java 21, with a major highlight being Project Jigsaw: 
- In Java 9, Project Jigsaw introduced the module system, allowing developers to create modular applications for better code organization and encapsulation (and also feel the pain of it).
- Java 10 brought local-variable type inference, simplifying code readability with the `var` keyword.  
- Java 11 marked a significant milestone as it was the first long-term support (LTS) release post-Java 8.  
- Further enhancements in Java 12-15 include improvements in garbage collection, records for concise data classes, text blocks for multiline strings, and enhanced switch expressions.  
- Java 16 and 17 introduced pattern matching and extended support for records.
- Java 18-21 have continued to refine the language with performance improvements and new features, with the big one being [Virtual Threads](https://openjdk.org/jeps/444)

Hopefully, I'll write something about virtual threads very soon. If you want me to write some more detailed content on the evolution of Java, let's leave a comment!

### Date is dead, long live to Instant!
I declare myself guilty: I learned the Date API back at school (it's been more than a decade now) and never challenged myself to learn newer and better alternatives. 

Date in Java isn't a complicated class, but often is rather *painful* to use[^5]. The main drawbacks of the Java Date API (prior to Java 8) included mutability, poor design, limited precision, **challenging time zone handling**, deprecated methods, inefficient formatting, lack of date arithmetic, poor internationalization support, and the need for external libraries like Joda-Time to address these issues. 

Java 8 introduced the `java.time` package, which overcame these limitations with a more modern, immutable, and comprehensive date and time API. Some of the main classes in the `java.time` package include:
- `LocalDate`: Represents a date without a time component.
- `LocalTime`: Represents a time without a date component.
- `LocalDateTime`: Combines date and time information without a time zone.
- `ZonedDateTime`: Represents a date and time with a time zone.
- `OffsetDateTime`: Combines date and time with an offset from UTC.
- `Instant`: Represents a point in time on the global timeline, typically used for timestamps.
- `Duration`: Represents a time-based amount, such as a duration between two instants.
- `Period`: Represents a date-based amount, such as a period between two dates.
- `ZoneId`: Represents a time zone identifier.
- `ZoneOffset`: Represents a fixed time zone offset from UTC.
- `DateTimeFormatter`: Used for parsing and formatting date and time values.
- `TemporalAdjusters`: Provides common adjustments to date and time values, such as finding the first day of the month.

These classes and interfaces provide a comprehensive and immutable API for handling date and time-related operations in Java, making it easier to work with dates, times, and time zones.

I ended up using a lot the class `Instant` which translates very well from the plain old `Date` and is easy to convert to `Timestamp` when working with JDBC.

Here are some examples:

1. Performing arithmetic operations
```java
Instant now = Instant.now();
Instant future = now.plus(Duration.ofHours(2)); // Add 2 hours to the current Instant
Instant past = now.minus(Duration.ofDays(1));   // Subtract 1 day from the current Instant
```
2. Parsing an `Instant` from a string:
```java
String timestamp = "2023-12-30T15:30:00Z";
Instant instant = Instant.parse(timestamp);
System.out.println("Parsed Instant: " + instant);
```
The default format is `DateTimeFormatter.ISO_INSTANT` which parses an instant in **UTC**, such as `2011-12-03T10:15:30Z`. 

3. Comparing `Instant` objects:
```java
Instant earlierInstant = Instant.parse("2023-12-30T12:00:00Z");
Instant laterInstant = Instant.parse("2023-12-30T15:00:00Z");

boolean isBefore = earlierInstant.isBefore(laterInstant);
boolean isAfter = laterInstant.isAfter(earlierInstant);

System.out.println("Is Before: " + isBefore); // true
System.out.println("Is After: " + isAfter);   // true
```
I have some more exciting stuff to share on the topic (hint: parse of partial dates with defaults), but I'll write them in a dedicated article.

## RedHat releases RHEL sources only via customer portal
In late 2020, Red Hat shifted its CentOS project from a traditional stable release model to a rolling release called CentOS Stream. This change brought both advantages and concerns. On the positive side, it allowed users access to more up-to-date features and updates, keeping them closer to the cutting edge of technology. However, it also introduced uncertainties regarding stability due to the potentially more frequent updates.  
This transformation sparked a debate within the Linux community, with some embracing the innovation and others lamenting the loss of CentOS's former role as a dependable downstream version of Red Hat Enterprise Linux.

I won't touch it lightly here: companies solely adopting CentOS for cost-cutting undermined the principles of open-source collaboration. This approach neglected community support and contribution, relying heavily on a single company to carry on the heavy work. I can contest the way Red Hat did it, but I can't contest the reason.

{{< figure src="meme_oss_spending.jpg" title="Companies neglecting OSS" >}}

Italian companies, which believe me, don't know how basic IT works (imagine if they know anything about open-source), seem to like Debian as an alternative to CentOS at least from my limited point of observation.

After this recap of the last 2 years, let's get back to 2023, specifically June 21st: [Red Hat will now only be releasing the source code for RHEL RPMs behind their customer portal](https://www.redhat.com/en/blog/furthering-evolution-centos-stream).

They effectively killed downstream forks: namely RockyLinux and AlmaLinux which were born as replacements of CentOS.

I don't think IBM was rooting for a dumb solution to increase sales but rather Red Hat forcing the hand on the same problem exposed in the previous paragraphs: companies using forks to cut down costs (remember, IT is still seen as a mere cost). 

I didn't like this move, but again I can't contest the fact that open-source doesn't grow on trees. Companies have to understand it.

There is still a debate going on and [more tech players are dropping bombs](https://www.phoronix.com/news/SUSE-Is-Forking-RHEL); I will try to keep myself updated.

At least all this mess gave me a chance to try AlmaLinux (I loved it!) and learn the difference between 1:1 compatibility and ABI compatibility.

## HashiCorp vs OpenTofu
It's been a hot summer, so hot that Red Hat was not the only one to add chaos to the open-source ecosystem: [HashiCorp changed the licensing of its open-source products from Mozilla Public License 2.0 (MPL 2.0) to Business Source License 1.1 (BUSL 1.1)](https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license).

As a response to it, the Linux Foundation forked Terraform (a software to write infrastructure as code) creating OpenTofu and [its manifesto](https://opentofu.org/manifesto).

I don't have strong opinions here since I wasn't familiar with Terraform, I will only say that this mess happened the moment I chose to learn it. Maybe it's me who brings bad luck 😒.

On the study side, I'll go with OpenTofu: someone has to read that documentation to catch mistakes (if there are any) and contribute to it if able to. But I'll try my best to apply my playbooks to Terraform too; flexibility isn't a bad thing to achieve and I'm pretty sure it will pay me back on my professional career.

## 2023 was the year of Linux on desktop!
Just kidding 😉.

<video loop autoplay>
    <source src="joke-jk.mp4" type="video/mp4" />
</video>

It's not in a bad spot anyway. With Valve pushing hard on its Steam Deck, Linux received a lot of love to: drivers, firmware and gaming-related stuff. Games are a good way to drive innovation.

## PipeWire hits 1.0.0!
There would be a lot more to talk about, but I want to close the article (which is already too long) with some nice news: **PipeWire has reached version 1.0.0!**

Since it's been introduced in Fedora I haven't had a single crash or inconsistency, *I love it when a plan comes together* [^6].

A big thank you to all the contributors!

## Closing toughs
I'm not the "new year new me" type of person, but it wouldn't be a complete recap with at least one goal for the next year.

I don't like empty goals like "become a better version of myself" (I leave it to the TikTok crowd) nor do I pretend to end conflicts; I'll simply stick with a clear objective: **do something about my sleep quality**.

That's all folks!

If you managed to survive this long article I thank you and I wish you a happy new year (that I hope it will be better than 2023), if you didn't... oh well... thanks anyway and *many good things*.
<video loop autoplay>
    <source src="im-watching-you-charles-reese.mp4" type="video/mp4" />
</video>


[^0]: Or like a friend of mine would like to say: "Sfidante"
[^1]: Fellow citizens will recognize something familiar
[^2]: Changelog + blog... I know, I'm so freaking smart
[^3]: Meta has been designated as *gatekeeper* together with Alphabet (Google), Amazon, Apple, ByteDance and Microsoft
[^4]: They are testing out an ActivityPub implementation
[^5]: I still remember the pain of having to debug a live service that was printing nonsense errors. It was [SimpleDateFormat](https://docs.oracle.com/javase%2F7%2Fdocs%2Fapi%2F%2F/java/text/SimpleDateFormat.html) that wasn't thread-safe.
[^6]: Do you recognize it?