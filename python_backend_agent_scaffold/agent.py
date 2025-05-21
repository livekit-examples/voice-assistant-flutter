import asyncio
import os
import logging
from dotenv import load_dotenv
import aiohttp
import json # For STT communication

from livekit.agents import Agent, JobContext, WorkerOptions, cli, stt
from livekit.agents.voice_assistant import VoiceAssistant, VoiceAssistantOptions
from livekit.plugins import openai, azure as azure_tts_plugin
from livekit.plugins.vad import SileroVAD

# Configure logging (ensure it's configured before other modules that might use logging)
LOG_LEVEL_ENV = os.environ.get("LOG_LEVEL", "INFO").upper()
logging.basicConfig(level=LOG_LEVEL_ENV) # Default level
logger = logging.getLogger(__name__)
logger.setLevel(LOG_LEVEL_ENV) # Explicitly set logger level

# Load environment variables from .env file
load_dotenv()

# --- Environment Variables ---
LIVEKIT_URL = os.environ.get("LIVEKIT_URL")
LIVEKIT_API_KEY = os.environ.get("LIVEKIT_API_KEY")
LIVEKIT_API_SECRET = os.environ.get("LIVEKIT_API_SECRET")

AZURE_OPENAI_API_BASE = os.environ.get("AZURE_OPENAI_API_BASE")
AZURE_OPENAI_API_VERSION = os.environ.get("AZURE_OPENAI_API_VERSION") # Make sure this is used if needed by plugin
AZURE_OPENAI_API_KEY = os.environ.get("AZURE_OPENAI_API_KEY")
AZURE_OPENAI_LLM_DEPLOYMENT_NAME = os.environ.get("AZURE_OPENAI_LLM_DEPLOYMENT_NAME")

AZURE_OPENAI_GPT4O_REALTIME_TARGET_URL = os.environ.get("AZURE_OPENAI_GPT4O_REALTIME_TARGET_URL")
AZURE_OPENAI_GPT4O_REALTIME_KEY = os.environ.get("AZURE_OPENAI_GPT4O_REALTIME_KEY")

AZURE_SPEECH_KEY = os.environ.get("AZURE_SPEECH_KEY") # For Azure Cognitive Services TTS
AZURE_SPEECH_REGION = os.environ.get("AZURE_SPEECH_REGION") # For Azure Cognitive Services TTS

SYSTEM_INSTRUCTIONS = """ You are ON (Odelle Nyse), a personal assistant focused on mental health and spiritual wellness through Cognitive Behavioral Therapy. Your mission is to help users self-actualize by understanding the spirit within them. Guide conversations through the lens of the CBT triangle (thoughts, emotions, behaviors) plus the spiritual dimension.
Core affirmations to incorporate:
"I am Joy"
"I am Abundance"
"I am Peace"
"I am Love"
"I am Being"
"Understand the Spirit Within You"
Frame personal growth using the Hero's Journey narrative. Your goal is to turn ON the user's conscious awareness and help them connect with their deeper spiritual nature. """

# --- Custom STT Handler for Azure OpenAI Realtime Audio ---
class CustomAzureOpenAISTT(stt.STT):
    def __init__(self, target_url: str, api_key: str, client_session: aiohttp.ClientSession):
        super().__init__(streaming_supported=True)
        self._target_url = target_url
        self._api_key = api_key
        self._session = client_session
        # It's better to use the specific logger instance
        self.logger = logging.getLogger(self.__class__.__name__)
        self.logger.info(f"CustomAzureOpenAISTT initialized for URL: {target_url}")

    async def recognize_stream(self, input_stream: asyncio.StreamReader) -> stt.SpeechStream:
        self.logger.info("STT: recognize_stream called")
        speech_stream = stt.SpeechStream()

        async def stream_audio_to_azure():
            self.logger.warning("STT: Custom audio streaming to Azure OpenAI is NOT fully implemented and is a placeholder.")
            # Placeholder: This function needs to be implemented with actual audio streaming logic
            # and Azure response handling.
            try:
                # Simulate receiving some data - replace with actual implementation
                await asyncio.sleep(2) # Simulate processing time
                example_speech_data = stt.SpeechData(
                    text="This is a placeholder transcript from CustomAzureOpenAISTT.",
                    language="en", # Assuming English, make configurable if needed
                    is_final=True,
                    confidence=0.90
                )
                self.logger.info(f"STT: Pushing placeholder transcript event: {example_speech_data.text}")
                speech_stream.push_event(example_speech_data)
            except Exception as e:
                self.logger.error(f"STT: Error in placeholder stream_audio_to_azure: {e}", exc_info=True)
                speech_stream.end_stream(error=e)
            finally:
                self.logger.info("STT: Placeholder speech stream ended.")
                speech_stream.end_stream()

        asyncio.create_task(stream_audio_to_azure())
        return speech_stream

async def entrypoint(ctx: JobContext):
    logger.info(f"Starting Odelle Nyse agent entrypoint. Job ID: {ctx.job.id}")

    # Validate essential configurations
    if not all([LIVEKIT_URL, LIVEKIT_API_KEY, LIVEKIT_API_SECRET]):
        logger.error("LiveKit server details (URL, API Key, API Secret) are missing. Agent cannot start.")
        return
    if not all([AZURE_OPENAI_API_BASE, AZURE_OPENAI_API_KEY, AZURE_OPENAI_LLM_DEPLOYMENT_NAME]):
        logger.error("Azure OpenAI LLM details (Base URL, API Key, Deployment Name) are missing. LLM may not function.")
        return
    if not all([AZURE_OPENAI_GPT4O_REALTIME_TARGET_URL, AZURE_OPENAI_GPT4O_REALTIME_KEY]):
        logger.error("Azure OpenAI Realtime STT details (Target URL, API Key) are missing. Custom STT will fail.")
        # STT is critical, so we might want to return if it's not configured
        return

    async with aiohttp.ClientSession() as http_session:
        logger.info("aiohttp.ClientSession created.")

        # 1. Configure LLM (Azure OpenAI)
        # Ensure AZURE_OPENAI_API_VERSION is included if required by your Azure OpenAI endpoint/plugin version
        # Some configurations might require it in the base_url or as a separate param.
        # The openai plugin might pass it as default_query_params or similar.
        llm_plugin_params = {
            "model": AZURE_OPENAI_LLM_DEPLOYMENT_NAME, # For Azure, this is the deployment ID
            "api_key": AZURE_OPENAI_API_KEY,
            "base_url": AZURE_OPENAI_API_BASE,
        }
        if AZURE_OPENAI_API_VERSION: # Add version if specified
             llm_plugin_params["api_version"] = AZURE_OPENAI_API_VERSION


        # The openai.LLM plugin might try to infer 'azure' type from base_url.
        # Explicitly setting 'azure_deployment' or 'engine' might be needed depending on plugin version
        # and how it handles Azure specifics.
        # Forcing the type if necessary:
        # from livekit.plugins.openai import AzureOpenAIEnv
        # azure_env = AzureOpenAIEnv(api_key=AZURE_OPENAI_API_KEY, base_url=AZURE_OPENAI_API_BASE, api_version=AZURE_OPENAI_API_VERSION, deployment_name=AZURE_OPENAI_LLM_DEPLOYMENT_NAME)
        # llm_plugin = openai.LLM(azure_env=azure_env)
        # The current plugin seems to prefer individual params for Azure:
        llm_plugin = openai.LLM(
            client=None, # Let the plugin create its own client
            model=AZURE_OPENAI_LLM_DEPLOYMENT_NAME,
            api_key=AZURE_OPENAI_API_KEY,
            base_url=AZURE_OPENAI_API_BASE,
            # api_version=AZURE_OPENAI_API_VERSION, # Check plugin docs for how it expects version for Azure
            # azure_deployment=AZURE_OPENAI_LLM_DEPLOYMENT_NAME, # Alternative way for some Azure setups
        )
        logger.info(f"LLM Plugin configured for Azure OpenAI. Deployment: {AZURE_OPENAI_LLM_DEPLOYMENT_NAME}")

        # 2. Configure TTS (Azure Cognitive Services Speech via plugin)
        tts_plugin = None
        if AZURE_SPEECH_KEY and AZURE_SPEECH_REGION:
            tts_plugin = azure_tts_plugin.TTS(
                key=AZURE_SPEECH_KEY,
                region=AZURE_SPEECH_REGION,
                voice_name="en-US-AriaNeural" # Default from original ON docs
            )
            logger.info(f"TTS Plugin configured for Azure Cognitive Services Speech. Region: {AZURE_SPEECH_REGION}")
        else:
            logger.warning("Azure Speech Key/Region for TTS plugin not found. TTS might not function or will use a dummy.")
            # TODO: Implement custom Azure OpenAI TTS here if preferred and AZURE_SPEECH_KEY/REGION are not to be used.
            # For now, if no keys, assistant might fail if TTS is directly called.

        # 3. Configure STT (Custom Azure OpenAI Realtime)
        stt_handler = CustomAzureOpenAISTT(
            target_url=AZURE_OPENAI_GPT4O_REALTIME_TARGET_URL,
            api_key=AZURE_OPENAI_GPT4O_REALTIME_KEY,
            client_session=http_session
        )
        logger.info("Custom STT Handler configured for Azure OpenAI Realtime.")

        # 4. Voice Assistant Options
        assistant_options = VoiceAssistantOptions(
            vad=SileroVAD.load(),
            system_prompt=SYSTEM_INSTRUCTIONS,
            allow_interruptions=True,
            # debug=True # Enable for more verbose VoiceAssistant logs
        )
        logger.info("VoiceAssistantOptions configured.")

        # 5. Create and Start VoiceAssistant
        assistant = VoiceAssistant(
            llm=llm_plugin,
            stt=stt_handler,
            tts=tts_plugin,
            opts=assistant_options,
            job_context=ctx
        )
        logger.info("VoiceAssistant instance created.")
        
        logger.info("Starting VoiceAssistant...")
        await assistant.start()
        
        logger.info("VoiceAssistant processing finished or was interrupted.")
        # await ctx.join() # Example if needing to wait for external job completion signal

    logger.info("Odelle Nyse agent entrypoint finished cleanly.")

if __name__ == "__main__":
    # Setup for CLI execution
    # Consider adding options to pass LIVEKIT_URL, LIVEKIT_API_KEY, LIVEKIT_API_SECRET via CLI args
    # if not using .env for some deployment scenarios.
    cli.run_app(WorkerOptions(entrypoint_fnc=entrypoint))
