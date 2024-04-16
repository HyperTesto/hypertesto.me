---
title: A simple script to migrate plain markdown files to hugo page bundles
date: 2023-06-26T19:59:18+02:00
draft: false
description: ""
tags:
  - hugo
  - Bash
---
I’m activating multi-language for my website, and I've decided to work with page bundles to manage content translations.

I'll write more about hugo content management soon (hopefully),
but for the scope of this post, let's say page bundles are very handy for this use case (and in general).

But what is a Hugo page bundle and how does it differ from normal markdown files?  
In a nutshell it's just a directory with a file named `index.md` inside. Exciting, isn't it?

## Conversion algorithm

Let's suppose to have a blog post saved as `content/my-awesome-post.md`; converting plain markdown file to this format it's a 3 step operation:

1. Extract the slug from filename: `my-awesome-post.md` --> `my-awesome-post`
2. Create a directory with the extracted name: `content/my-awesome-post/`
3. Move original file inside the new directory and rename it `index.md`

The final result will be `content/my-awesome-post/index.md`

## Put it into a Bash script
Technically speaking, the following is not a bash script, but one single command: it's useful to explain the overall idea behind it without getting too much into *bashism*.

If you don't want the explanation,
you can directly jump to the [actual script](https://github.com/HyperTesto/hypertesto.me/blob/master/utils/migrate_to_page_bundle.sh) on GitHub.

{{< alert >}}
Keep in mind both the script and the following command are destructive operations. I suppose you’re working with git so in case of a disaster you can rollback, if you aren’t, be sure to have a backup! 
{{< /alert >}}

Now let's get into action:

```bash
find /my/awesome/directory -name "*.md" -not  -name "index*.md" -not -name "_index*.md" -exec bash -c '
    BASE_DIR=$1
    BUNDLE_DIR="$BASE_DIR/$(basename $2 .md)"  
    SOURCE_FILE=$2
    TARGET_FILE=$BUNDLE_DIR/index.md
    echo "Moving $SOURCE_FILE to $TARGET_FILE"
    mkdir $BUNDLE_DIR 
    mv $SOURCE_FILE $TARGET_FILE
' bash /my/awesome/directory {} \;
```
* `find` look for files ending in `.md` but exclude [leaf and branch bundle indexes](https://gohugo.io/content-management/page-bundles/#leaf-bundles)
* For each matched file launch another bash command that takes the lookup directory `/my/awesome/directory` as first parameter and the matched file itself `{}` as second parameter
* The "subcommand" implements the algorithm described [above](#conversion-algorithm) and moves the source file to its new location

I've successfully migrated all the content of this blog to page bundles with this simple and hacky solution ([commit](https://github.com/HyperTesto/hypertesto.me/commit/c6ff304ee7d88d842ab50bbbd2fc768f6ecf5b5a)).
I hope this simple script will be useful to you too!

