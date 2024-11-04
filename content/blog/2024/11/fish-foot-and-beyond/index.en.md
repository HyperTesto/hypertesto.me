---
title: "Fish, Foot and beyond: a terminal setup that finally smells right 🐟👣"
date: 2024-11-04T19:09:35+01:00
draft: false
tags: "linux"
categories: "linux"
authors: "hypertesto"
---
Picture this: there I was, happily using Tilix for my terminal needs on Fedora.
Split panes, dropdown terminal, the whole shebang. Life was good... until it wasn't.
Recent Fedora updates started making Tilix throw tantrums, and suddenly my trusty terminal setup felt like that friend who keeps flaking on plans.

After some soul-searching (and a lot of Reddit threads), I realized I needed to break down my terminal needs: a rock-solid Wayland-native terminal emulator, a shell that wouldn't make me hate scripting, and a multiplexer that could keep up with modern workflows.

Enter the new trio: [Foot](https://codeberg.org/dnkl/foot), [Fish](https://fishshell.com/), and [Zellij](https://zellij.dev/). Yes, I know - between Fish and Foot, this setup sounds like it came from a very weird pet shop. But stick with me here!

## Sometimes less is more
For terminal emulation I wanted something simple, stable, and Wayland-native. Foot checked all these boxes and then:
- is blazing fast thanks to being written in C
- is hardware accelerated rendering (hello, smooth scrolling!)
- has minimal dependencies (goodbye, random breakages!)
- has simple configuration in a single file
- has [Sixel](https://en.wikipedia.org/wiki/Sixel) support for those fancy terminal graphics

Now, I'll be honest - when people talked about "fast terminals," I used to roll my eyes. How fast does a terminal need to be to show some text? Well, turns out I was wonderfully wrong - you don't realize how much terminal lag affects your workflow until you try a faster one.


## Life's too short for boring shells!
Remember the first time you saw someone's terminal autocomplete something magical? That's Fish, all day, every day; no hacky setups required.
Here's what made me fall hook, line, and sinker for it:

- Fish remembers your commands and suggests them as you type. It's like having a very eager assistant who actually knows what they're doing. Autosuggestions feel like mind-reading!
- Colors! So many colors! And they actually mean something (unlike my old prompt that I made pretty but couldn't remember what anything meant)
- No more `if [ -f something ]` syntax that looks like it came from the 80s. Fish makes scripting feel like actual programming

Sure, there's the occasional _"this shell script isn't compatible with Fish"_ moment, but let's be real - when was the last time you looked at a bash script and thought "wow, this is so intuitive"? Fish makes the trade-off simple: give up some backwards compatibility, get a shell that feels like it was actually designed in this century. And for those rare occasions when you really need to run a bash just prefix it with `bash` and move on with your life.

## Getting on the right Foot
First things first - let's get our Foot in the door (sorry, not sorry).
On Fedora, it's as simple as this:

```bash
sudo dnf install foot fish zellij
```

Easy, isn't it?

And of course, `CTRL-ALT-T` still spawns my terminal - some habits are worth keeping.
![Gnome Shortcut](gnome-shortcut.png "Shortcut configured on Gnome")
### Foot configuration
My Foot configuration is straightforward but purposeful. Let's break it down:

```ini
[main]
font=JetBrains Mono:size=16
initial-window-mode=fullscreen
shell=/usr/bin/fish
```

The main section is minimal:
- JetBrains Mono because it's a fantastic monospace font with great readability
- terminals starts fullscreen because that's what I ended up doing as first action every time I opened a Tilix in my old setup
- last but not least, of course, Fish is set as the default shell because that's the whole point of this setup.

```ini
[colors]
# A wild variety of Catppuccin Mocha colors...
```

While I'm unsure about the theme interaction with zellij, it's working fine, and so I'll briefly give an overview of it. I'm using Catppuccin Mocha - a soothing dark theme that's easy on the eyes. It provides:

- A dark background (`1e1e2e`) with light text (`cdd6f4`) for good contrast
- Carefully chosen colors for different terminal elements
- Nice selection colors that don't make you squint (I am colorblind myself)
- Special colors for search and jump labels that actually stand out

The URLs are highlighted in a gentle blue (`89b4fa`) - because clickable links should be obvious but not screaming for attention.
Nothing fancy, no transparency effects or padding tweaks - just a clean, functional setup that gets out of your way while being pleasant to look at.

### Fish configuration
My Fish config is minimalist but gets the job done. Let's see what's happening here:

```fish
set -x ZELLIJ_AUTO_EXIT true
if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (zellij setup --generate-auto-start fish | string collect)
end
```

- The first line sets up Zellij to automatically exit when the last pane closes (as easy as pressing `CTRL-D`). It's a quality-of-life setting - when you're done with your last terminal window, Zellij closes cleanly instead of hanging around with an empty session.
- Then, we check if we're in an interactive shell (as opposed to running a script)
- Lastly, we auto-start Zellij using its built-in Fish integration. The string collect bit ensures all the output from the setup command is handled properly

The result? Every time I open Foot, it automatically launches Fish, which automatically starts Zellij. No manual steps, no "oops I forgot to start my multiplexer" moments - everything just flows.
You know those tiny tasks that seem insignificant? _"Oh, it's just two keypresses to start Zellij..."_ But when you do them 20 times a day, those micro-interruptions add up and break your flow. Now my terminal setup just works, and I can focus on what I actually opened the terminal for in the first place.

### Zellij configuration
Nothing, it works out of the box! No question asked.
![Zellij in action](zellij-in-action.png "Zellij in action with 1 tab and 2 panels")
Out of the box, Zellij shows you what shortcuts you can use right in the status bar.
It's a nice way to learn while you work, until your fingers start doing their thing automatically.

### A small note about SSH
Here's a little gotcha I discovered when working with remote servers. By default, Foot uses its own terminal type (`foot` or `foot-direct`), which is great for local use but can confuse some remote hosts. Adding this tiny bit to my `~/.ssh/config`:

```config
Host *
SetEnv TERM=xterm-256color
```

This tells SSH to identify as the widely-supported `xterm-256color` when connecting to remote machines.
It's a simple fix that prevents those annoying "unknown terminal type" errors and weird formatting issues when SSHing into servers.
Sure, you lose some of Foot's fancy features on remote connections, but it's a fair trade for having everything just work™ without
having to install terminal definitions on every server you access.

## Future experiments: down the Zellij rabbit hole
While this setup is already solid, I've got my eyes on some interesting Zellij possibilities. First up is the SSH client multiplexing - being able to manage multiple SSH connections in a single Zellij session, with each remote server neatly organized in its own space. Gone would be the days of juggling terminal windows trying to find that one production session.

Zellij's plugin system caught my attention too. Since plugins can be written in any language that compiles to WebAssembly, I might try my hand at building something that scratches my own itches - maybe something to streamline my SSH session management or Git workflow. The project is still quite active, so there's room to play around.

I also want to dig into Foot's session management. The idea is to have a single main Foot window that all new terminal instances connect to when I hit my terminal shortcut. Should be doable with Foot's `--server` mode and some window manager tweaks. That way I could keep my workflow exactly the same but avoid the window clutter.

These might be solutions looking for problems, but hey - isn't that half the fun of terminal customization? Plus, unlike my Tilix tweaking days, if something breaks, my base setup remains rock-solid. Stay tuned for potential updates if any of these experiments turn out particularly useful!

## Final considerations
After a few months with this setup, I can't imagine going back. The combination of Foot's speed, Fish's smarts, and Zellij's flexibility has genuinely improved my daily workflow. Sure, it took a bit of tweaking to get everything just right, but that's the beauty of it - each piece is simple enough that customizing doesn't feel like solving a puzzle.

Looking back at my Tilix days, I realize sometimes "just works" beats "works with all the features." This setup is faster, more stable, and honestly, just more enjoyable to use. Plus, there's something satisfying about having a terminal setup that's both modern and respectful of system defaults. If you're on the fence about modernizing your terminal setup, consider this your sign to take the plunge - your future self will thank you.

Oh, and here's a neat thing about this setup: it doesn't touch your system's default shell at all. Bash remains as the system shell, handling all its traditional duties, while Fish only kicks in when you're actually using the terminal interactively. It's like having your cake and eating it too: the system keeps humming along with bash while you get all the nice Fish goodies.

_P.S. No Fish were harmed in the making of this terminal setup, though some bad shell scripts were rightfully abandoned.[^0]_

[^0]: I realized I haven't left any _foot_ notes in a post about Foot. Had to fix that!
