# Odelle Nyse - Final Review and Testing Guide

This guide provides final steps for reviewing your Odelle Nyse Flutter application setup, along with instructions for running the app and troubleshooting common issues.

## 1. Environment Configuration (`.env` file)

Before running the application, ensure you have created a `.env` file in the root of your Flutter project. You can do this by copying the `.env.example` file:

```bash
cp .env.example .env
```

Then, **edit the `.env` file** and replace the placeholder values with your actual API keys and configuration:

```env
LIVEKIT_URL=your_actual_livekit_server_url # e.g., wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your_actual_livekit_client_token # If using direct token auth
LIVEKIT_API_SECRET= # This is typically server-side, ensure client token is used for LIVEKIT_API_KEY or a new LIVEKIT_CLIENT_TOKEN var
AZURE_SPEECH_KEY=your_actual_azure_speech_key
AZURE_SPEECH_REGION=your_actual_azure_region

# The following are primarily for your backend agent, but ensure they are set up there.
# OPENAI_API_KEY=your_actual_openai_api_key
# DEEPGRAM_API_KEY=your_actual_deepgram_api_key

# If using LiveKit Cloud Sandbox Token Server for development:
LIVEKIT_SANDBOX_ID=your_actual_sandbox_id
```

**Important Notes on LiveKit Configuration (via `lib/services/token_service.dart`):**
*   If `LIVEKIT_URL` and `LIVEKIT_API_KEY` (interpreted as a client token) are set in `.env`, they will be used.
*   If they are not set, the app will attempt to use `LIVEKIT_SANDBOX_ID` to connect via the LiveKit Cloud Sandbox Token Server.
*   Ensure your backend agent is separately configured with its necessary API keys as detailed in `BACKEND_CONFIGURATION_GUIDE.md`.

## 2. Backend Agent Setup

Ensure your Python backend agent is configured and running as per the instructions in `BACKEND_CONFIGURATION_GUIDE.md`. This includes:
*   Correct `requirements.txt`.
*   Azure TTS integration in `agent.py`.
*   Odelle Nyse specific system instructions in `agent.py`.
*   All necessary API keys (OpenAI, Deepgram, Azure, LiveKit server-side) set in the backend's environment.

**Start your backend agent (example command):**
```bash
cd path/to/your/backend_agent
python agent.py # Or your specific run command
```

## 3. Running the Flutter App

1.  **Install Dependencies:**
    If you haven't already, or if `pubspec.yaml` changed, get the Flutter packages:
    ```bash
    flutter pub get
    ```
2.  **Run the App:**
    ```bash
    flutter run
    ```
    Select your target device (iOS simulator/device, Android emulator/device, or Chrome for web).

## 4. Testing Voice Functionality

Once the app is running and your backend agent is active:
1.  Navigate to the voice interaction screen (e.g., by tapping the microphone button on the `HomeScreen`).
2.  Attempt to connect to a LiveKit room (this should happen automatically or via a connect button if you modify the UI later).
3.  Test voice interaction with some basic prompts relevant to Odelle Nyse:
    *   "Hello, how are you today?"
    *   "I'm feeling anxious about work."
    *   "Help me practice an affirmation." (e.g., "Help me practice the 'I am Joy' affirmation")
    *   "Tell me about the Hero's Journey and where I might be on it."

## 5. Common Issues & Solutions (from project documentation)

*   **LiveKit Connection Issues:**
    *   **Problem:** Unable to connect to LiveKit server.
    *   **Solution:** Verify your `LIVEKIT_URL` and client token (or `LIVEKIT_SANDBOX_ID`) in the `.env` file are correct and that your LiveKit server/sandbox is operational. Check your backend agent's LiveKit server-side configuration.
*   **Missing API Keys (Backend):**
    *   **Problem:** Backend agent fails with authentication errors.
    *   **Solution:** Verify all API keys (OpenAI, Deepgram, Azure) are correctly set in your backend agent's environment variables.
*   **Azure TTS Issues:**
    *   **Problem:** Text-to-speech not working or producing errors.
    *   **Solution:** Check your `AZURE_SPEECH_KEY` and `AZURE_SPEECH_REGION` in both the Flutter app's `.env` (if used directly by client for some reason, though typically backend) and especially in the backend agent's environment. Ensure the selected voice (e.g., "en-US-AriaNeural") is available in your Azure region.
*   **Local Testing Limitations / Voice Recognition Issues:**
    *   **Problem:** Voice recognition performs poorly in testing.
    *   **Solution:** Test in a quiet environment. Ensure microphone permissions are granted for the app on your device/emulator. Check the quality of your microphone.
*   **Flutter Build Issues:**
    *   **Problem:** App fails to build.
    *   **Solution:** Run `flutter doctor` to check for any Flutter SDK issues. Ensure all dependencies in `pubspec.yaml` are compatible. Try `flutter clean` then `flutter pub get`.

## 6. Deployment Preparation

(Refer to the original "ON: Project Setup & Configuration Guide" for detailed deployment steps for iOS and Android, including App Store and Play Store preparation.)

---
This guide should help you get the Odelle Nyse app running. Remember to consult the `README.md`, `ASSET_GUIDE.md`, and `BACKEND_CONFIGURATION_GUIDE.md` for other important setup details.
```
