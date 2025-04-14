import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart'
    show RoomContext, TranscriptionBuilder;
import 'package:provider/provider.dart';
import './widgets/control_bar.dart';
import './services/token_service.dart';
import 'widgets/agent_status.dart';
import 'widgets/transcription_widget.dart';

// Load environment variables before starting the app
// This is used to configure the LiveKit sandbox ID for development
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

// Main app configuration with light/dark theme support
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const VoiceAssistant(),
    );
  }
}

/// The main voice assistant screen that manages the LiveKit room connection
/// and displays the status visualizer and control bar
class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({super.key});
  @override
  State<VoiceAssistant> createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  // Create a LiveKit Room instance with audio visualization enabled
  // This is the main object that manages the connection to LiveKit
  final room = Room(roomOptions: const RoomOptions(enableVisualizer: true));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provide the TokenService and RoomContext to descendant widgets
      // TokenService handles LiveKit authentication
      // RoomContext provides LiveKit room state and operations
      providers: [
        ChangeNotifierProvider(create: (context) => TokenService()),
        ChangeNotifierProvider(create: (context) => RoomContext(room: room)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voice Assistant'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: TranscriptionBuilder(
                    builder: (context, roomCtx, transcriptions) {
                      return TranscriptionWidget(
                        textColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        transcriptions: transcriptions,
                      );
                    },
                  ),
                ),
                // Status widget shows the agent's audio visualization
                const Expanded(
                  flex: 3,
                  child: AgentStatusWidget(),
                ),
                // Control bar handles room connection and audio controls
                const Expanded(
                  flex: 3,
                  child: ControlBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
