<a href="https://livekit.io/">
  <img src="./.github/assets/livekit-mark.png" alt="LiveKit logo" width="100" height="100">
</a>

# Flutter Voice Assistant

<p>
  <a href="https://cloud.livekit.io/projects/p_/sandbox"><strong>Deploy a sandbox app</strong></a>
  •
  <a href="https://docs.livekit.io/agents/overview/">LiveKit Agents Docs</a>
  •
  <a href="https://livekit.io/cloud">LiveKit Cloud</a>
  •
  <a href="https://blog.livekit.io/">Blog</a>
</p>

A simple example AI voice assistant using the LiveKit [Flutter SDK](https://github.com/livekit/client-sdk-flutter).

This example is made for iOS, macOS, and Android.

## Installation

### Using the LiveKit CLI

The easiest way to get started is to use the [LiveKit CLI](https://docs.livekit.io/home/cli/cli-setup/). Run the following command to bootstrap this template:

```bash
lk app create --template voice-assistant-flutter [--sandbox <sandboxID>]
```

Then follow instructions to [set up an agent](#agent) for your app to talk to.

### Manual Installation

Clone the repository and then either create a `.env` with a `LIVEKIT_SANDBOX_ID` (if using a hosted Token Server via [Sandboxes](https://cloud.livekit.io/projects/p_/sandbox)), or open `token_service.dart` and add your [manually generated](#token-generation) URL and token.

Then follow instructions to [set up an agent](#agent) for your app to talk to.

## Token Generation

In production, you will want to host your own token server to generate tokens in order for users of your app to join LiveKit rooms. But while prototyping, you can either hardcode your token, or use a hosted Token Server via [Sandboxes](https://cloud.livekit.io/projects/p_/sandbox)). 

## Agent

This example app requires an AI agent to communicate with. You can use one of our example agents in [livekit-examples](https://github.com/livekit-examples/), or create your own following one of our [agent quickstarts](https://docs.livekit.io/agents/quickstart/).
