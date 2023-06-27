---
title: A Hugo shortcode to get my current age
date: 2023-06-27T20:30:33.076Z
draft: false
description: ""
tags:
  - hugo
---
I admit it took me more time to hack this together rather than manually update the date every year for the next 30 years :smile:.

I created a file named `myAge.html` and placed inside `layouts/shortcodes` directory:

```html
{{ $birth := "1994-01-26" | time }}
{{ $today := now }}
{{ $age := sub $today.Year $birth.Year }}
{{ $monthDiff := sub $today.Month $birth.Month }}
{{ $dayDiff := sub $today.Day $birth.Day }}

{{ if (gt $monthDiff 0) }}
    {{ $age }}
{{ else if (lt $monthDiff 0) }}
    {{ sub $age 1 }}
{{ else }}
    {{ if (ge $dayDiff 0) }}
        {{ $age }}
    {{ else }}
        {{ sub $age 1 }}
    {{ end }}
{{ end }}
```

Basically i calculate the age as the difference between current and birth year; then subtract 1 if the current day of the year is before the birth one.
Ugly but there aren't many other ways to do it without applying math sorceries to account for months with different number of days and leap years.

To call the shortcode just place `{{</* myAge */>}}` inside markdown content:

> Hello, I'm {{< myAge >}} years old!

Of course there is room of improvement: for example `$birth` could be a shortcode parameter instead of an hardcoded value.

Oh, and don't forget the date doesn't update unless you rebuild the site! So you either have to rebuild once a year, or schedule some automatic update.