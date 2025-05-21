# Odelle Nyse - Backend Configuration Guide

This guide outlines the necessary modifications to your Python backend (presumably based on the `voice-pipeline-agent-python` template) to integrate with the Odelle Nyse (ON) application specifics.

## 1. Update `requirements.txt`

You need to add the Azure Speech SDK for text-to-speech capabilities. Modify your `requirements.txt` to include:

```text
livekit-agents>=1.0.0 # Ensure this or a compatible version is present
livekit-plugins-openai>=1.0.0 # Ensure this or a compatible version is present
livekit-plugins-deepgram>=1.0.0 # Ensure this or a compatible version is present
livekit-plugins-silero>=1.0.0 # Ensure this or a compatible version is present
livekit-plugins-azure>=1.0.0 # Add this for Azure TTS
livekit-plugins-turn-detector>=1.0.0 # Ensure this or a compatible version is present
python-dotenv>=0.20.0 # Ensure this or a compatible version is present
# Add any other existing dependencies...
```
After updating, reinstall the dependencies:
```bash
pip install -r requirements.txt
```

## 2. Update Backend Agent Logic (e.g., `agent.py`)

Modify your main agent file (e.g., `agent.py`) to incorporate Odelle Nyse's specific configurations:

### a. Import Azure TTS Plugin

Add the Azure TTS plugin to your imports:

```python
from livekit.plugins import azure # Add this
# ... other imports like deepgram, openai, silero, elevenlabs (if previously used)
```

### b. Update VoiceAssistant Initialization for Azure TTS

In your agent's entrypoint function (e.g., `async def entrypoint(ctx: JobContext):`), locate the `VoiceAssistant` initialization. You need to replace the existing TTS provider (e.g., `elevenlabs.TTS`) with `azure.TTS`.

Make sure you have your Azure Speech Key and Region set as environment variables (e.g., in your backend's `.env` file or system environment). The project's Flutter `.env.example` specifies `AZURE_SPEECH_KEY` and `AZURE_SPEECH_REGION`.

```python
import os # Make sure os is imported

# ... inside entrypoint function

# Replace ElevenLabs or other TTS with Azure TTS
# tts=elevenlabs.TTS() # Old
tts=azure.TTS(
    key=os.environ.get("AZURE_SPEECH_KEY"),
    region=os.environ.get("AZURE_SPEECH_REGION"),
    voice_name="en-US-AriaNeural", # As recommended in the project docs
)

assistant = VoiceAssistant(
    vad=silero.VAD.load(), # Or your chosen VAD
    stt=deepgram.STT(model="nova-3"), # Or your chosen STT
    llm=openai.LLM(model="gpt-4o-mini"), # Or your chosen LLM
    tts=tts, # Use the new Azure TTS instance
    chat_ctx=initial_ctx, # Make sure initial_ctx is defined with system_instructions
    # turn_detector=TurnDetector.load() # If you are using it
)
```

### c. Update System Instructions

The Odelle Nyse project requires specific system instructions for the LLM. Update the `system_instructions` variable in your agent file:

```python
system_instructions = """ You are ON (Odelle Nyse), a personal assistant focused on mental health and spiritual wellness through Cognitive Behavioral Therapy. Your mission is to help users self-actualize by understanding the spirit within them. Guide conversations through the lens of the CBT triangle (thoughts, emotions, behaviors) plus the spiritual dimension.

Core affirmations to incorporate:

"I am Joy"
"I am Abundance"
"I am Peace"
"I am Love"
"I am Being"
"Understand the Spirit Within You"
Frame personal growth using the Hero's Journey narrative. Your goal is to turn ON the user's conscious awareness and help them connect with their deeper spiritual nature. """

# Ensure this system_instructions variable is used when creating the initial chat context for the LLM
# For example:
# initial_ctx = llm.ChatContext().append(role="system", text=system_instructions)
```

### d. API Key Configuration for Backend
Ensure your backend environment (`.env` file for the Python agent) is configured with:
- `OPENAI_API_KEY`
- `DEEPGRAM_API_KEY`
- `AZURE_SPEECH_KEY`
- `AZURE_SPEECH_REGION`
- `LIVEKIT_API_KEY` (Server-side LiveKit key)
- `LIVEKIT_API_SECRET` (Server-side LiveKit secret)
- `LIVEKIT_URL` (Your LiveKit server URL)


## 3. Restart Your Backend Agent

After making these changes, ensure you restart your Python backend agent to apply them.

---
This guide assumes you are using a Python-based LiveKit agent. Adjust paths and commands if your setup differs.
```
