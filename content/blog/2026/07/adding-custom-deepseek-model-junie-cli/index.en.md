---
title: "Adding a custom DeepSeek model in Junie CLI (No YAML demons required)"
date: 2026-07-16T21:00:00+02:00
draft: false
description: "A step-by-step guide to wiring a custom DeepSeek model into Junie CLI: from JSON config to CLI flags and a stern talk about API keys."
tags:
  - junie
  - deepseek
  - ai
  - cli
  - llm
  - tools
categories:
  - post
authors:
  - hypertesto
---

I switched my Junie CLI default model to DeepSeek last month. The reason wasn't philosophical: Claude and GPT are great, but they cost real money when you're hammering a CLI for hours. DeepSeek is cheaper. Sometimes the best technical decision is the one your wallet makes for you.

The switch itself was anticlimactic. There's no `junie model add` wizard, no guided setup, and the `--help` output mentions custom models only in passing with a `--model` flag that reads like an afterthought. What you actually do is drop a JSON file into `~/.junie/models/` and… that's it. Junie picks it up.

This post documents that process: adding `deepseek-v4-pro` to Junie CLI, using the actual config format running on my machine right now.[^1]

[^1]: If you're looking for the accompanying Italian version of this post… there isn't one. Some topics just work better in English, and CLI config files are _definitely_ in that camp. *"Drop un JSON nella cartella models"* doesn't quite hit the same way.

## Why bother?

Before we touch any config, let's answer the obvious: *why not just use the built-in providers?*

Because in real life we optimize for different things at different times:

| You want… | So you reach for… |
|---|---|
| Latency minimization | a flash/fast variant |
| Deep refactors with context | a large-context model |
| Cost control on long sessions | a cheaper provider |
| Provider redundancy | a backup endpoint |
| Experimentation | whatever just dropped on HuggingFace |

If your tooling lets you swap models cleanly, you gain **operational sanity**. And operational sanity is underrated.

## Prerequisites

1. **Junie CLI installed.** You should already have `junie` on your `PATH`. Verify:

   ```bash
   junie --help
   ```

2. **A DeepSeek API key.** Get one from [platform.deepseek.com](https://platform.deepseek.com/). You'll need to top up credits.

3. **Basic JSON literacy.** No YAML, no TOML, no arcane DSL. Just one JSON file. You've got this.

## How Junie CLI discovers custom models

Junie looks for model definitions in **two default locations**:

- `~/.junie/models/`: global, available to all projects
- `<project>/.junie/models/`: per-project overrides

Each model is a single `.json` file. The filename becomes the model's identifier within Junie. So `~/.junie/models/deepseek.json` registers a model called… `deepseek`. Creative, I know.

You can also point Junie at additional directories with `--model-location <path>` if you prefer to keep your model configs in a dotfiles repo or shared volume.

## Step 1 — Create the model JSON

Create `~/.junie/models/deepseek.json` (or `<project>/.junie/models/deepseek.json` if you want it scoped to a single codebase):

```json
{
  "id": "deepseek-v4-pro",
  "baseUrl": "https://api.deepseek.com/chat/completions",
  "apiType": "OpenAICompletion",
  "apiKey": "sk-your-deepseek-api-key-here",
  "temperature": 0,
  "primaryModel": {
    "id": "deepseek-v4-pro"
  },
  "fasterModel": {
    "id": "deepseek-v4-flash"
  }
}
```

Let's unpack what each field does:

| Field | Purpose |
|---|---|
| `id` | The primary model identifier. Junie displays this in the model picker and passes it in API requests. |
| `baseUrl` | The endpoint Junie POSTs to. DeepSeek's API is OpenAI-compatible, so we point it at their chat/completions endpoint. |
| `apiType` | Tells Junie which request/response format to use. `"OpenAICompletion"` covers OpenAI, DeepSeek, and most compatible providers. |
| `apiKey` | Your API key. **Yes, it's plaintext in a JSON file.** We'll talk about this. |
| `temperature` | Controls response randomness. `0` means deterministic; bump it to `0.3`–`0.7` for more creative output. |
| `primaryModel.id` | The model ID sent in the API request body. This must match the DeepSeek model name exactly. |
| `fasterModel` | _(Optional)_ A lighter/faster model for quick tasks like inline autocomplete or summarization. |

### A stern word about `apiKey`

Yeah, it's sitting there in plaintext. I know. No, Junie doesn't currently read it from an environment variable for custom models[^2]. Your options:

- **Set restrictive file permissions:** `chmod 600 ~/.junie/models/deepseek.json`. At least other users on the system can't read it.
- **Use a LiteLLM proxy** as middleware (see [the LiteLLM section below](#bonus-using-litellm-as-a-proxy-no-api-key-in-config)): this keeps the key out of Junie's config entirely.
- **Accept it and don't commit the file** to a public dotfiles repo. You're an adult.

For what it's worth, Junie stores the key in your home directory, which on a single-user development machine is about as secure as any other dotfile with secrets in it. Not ideal, but not the end of the world either[^3].

[^2]: If you're reading this from the future and Junie _does_ support `apiKeyEnv` or similar: congratulations, the timeline is better than mine. Please update this post.
[^3]: *"Not the end of the world"* is the security posture equivalent of *"it compiles, ship it."* Take appropriate precautions.

## Step 2 — Use the model

Once the JSON file is in place, you have three ways to invoke it:

- **CLI flag (one-off)**

  ```bash
  junie --model custom:deepseek "Explain this function."
  ```
  This will start junie in interactive mode using the custom model defined previously in json configuration.

- **Interactive mode**

  Launch Junie interactively, then pick the model from the selector (usually `/model` or the equivalent model-switching shortcut):

  ```bash
  junie
  ```
  Your custom `deepseek` model should appear in the list alongside the built-in providers.

### Settings override (persistent default)

Edit `~/.junie/settings.json` and add or edit:

```json
{
  "modelForLaunch": "custom:deepseek",
}
```

Now every session starts with DeepSeek unless you override with `--model`.

---

## Step 3 — Verify it works

Before trusting it with a 400-line refactor, run a quick sanity check:

```bash
junie --model deepseek "Say hello and confirm which model you're running on."
```

If the response comes back coherent and the logs show `deepseek-v4-pro`, you're in business. If you get an auth error, double-check:

- The API key is correct and has credits
- The `baseUrl` ends with `/chat/completions` (no trailing slash weirdness)
- The `primaryModel.id` matches exactly what DeepSeek expects


## The bottom line

Junie CLI's custom model system is refreshingly straightforward: drop a JSON file in a directory, and you're done. No YAML anchors, no multi-file inheritance chains, no environment-variable indirection puzzles. Just a flat config that tells the CLI where to send requests and which model ID to use.

Is the plaintext API key ideal? No. But with file permissions and/or a LiteLLM proxy, you can mitigate the concern without adding much friction. For single user dev-machines it's a worth tradeoff.

Now go wire up your DeepSeek model and tell it to write you some code. Or a haiku about YAML. Your call.

Thanks for reading!
