import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as livekit
    show ConnectionState;
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import '../services/token_service.dart';
import 'package:livekit_components/livekit_components.dart';

/// Possible states for the control bar UI
/// - disconnected: Not connected to a LiveKit room
/// - connected: Successfully connected and streaming
/// - transitioning: Currently connecting or disconnecting
enum Configuration { disconnected, connected, transitioning }

/// The main control interface for the voice assistant
/// Handles:
/// - Connecting to LiveKit rooms
/// - Disconnecting from rooms
/// - Toggling microphone
/// - Displaying audio visualization
class ControlBar extends StatefulWidget {
  const ControlBar({super.key});

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  // Track connection state transitions
  bool isConnecting = false;
  bool isDisconnecting = false;

  // Helper to determine the current UI configuration based on connection state
  Configuration get currentConfiguration {
    if (isConnecting || isDisconnecting) {
      return Configuration.transitioning;
    }

    // Check the LiveKit room's connection state
    final roomContext = context.read<RoomContext>();
    if (roomContext.room.connectionState ==
        livekit.ConnectionState.disconnected) {
      return Configuration.disconnected;
    } else {
      return Configuration.connected;
    }
  }

  /// Connects to a LiveKit room by:
  /// 1. Generating random room/participant names
  /// 2. Getting connection details from TokenService
  /// 3. Connecting to the room using RoomContext
  /// 4. Enabling the microphone
  Future<void> connect() async {
    final roomContext = context.read<RoomContext>();
    final tokenService = context.read<TokenService>();

    setState(() {
      isConnecting = true;
    });

    try {
      // Generate random room and participant names
      // In a real app, you'd likely use meaningful names
      final roomName =
          'room-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';
      final participantName =
          'user-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';

      // Get connection details from token service
      final connectionDetails = await tokenService.fetchConnectionDetails(
        roomName: roomName,
        participantName: participantName,
      );

      if (connectionDetails == null) {
        throw Exception('Failed to get connection details');
      }

      // Connect to the LiveKit room
      await roomContext.connect(
        url: connectionDetails.serverUrl,
        token: connectionDetails.participantToken,
      );

      // Enable the microphone after connecting
      await roomContext.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      debugPrint('Connection error: $error');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  /// Disconnects from the current LiveKit room
  Future<void> disconnect() async {
    final roomContext = context.read<RoomContext>();

    setState(() {
      isDisconnecting = true;
    });

    await roomContext.disconnect();

    setState(() {
      isDisconnecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        // Show different buttons based on connection state
        Builder(builder: (context) {
          switch (currentConfiguration) {
            case Configuration.disconnected:
              return ConnectButton(onPressed: connect);

            case Configuration.connected:
              return Row(
                children: [
                  const AudioControls(),
                  const SizedBox(width: 16),
                  DisconnectButton(onPressed: disconnect),
                ],
              );

            case Configuration.transitioning:
              return TransitionButton(isConnecting: isConnecting);
          }
        }),

        const Spacer(),
      ],
    );
  }
}

/// Button shown when disconnected to start a new conversation
class ConnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConnectButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Start a Conversation'.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Button shown when connected to end the conversation
class DisconnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DisconnectButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      style: IconButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// (fake) button shown during connection state transitions
class TransitionButton extends StatelessWidget {
  final bool isConnecting;

  const TransitionButton({super.key, required this.isConnecting});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: null, // Disabled during transition
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        (isConnecting ? 'Connecting…' : 'Disconnecting…').toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Audio visualizer that displays thin bars that scale from the center
class LocalAudioVisualizer extends StatefulWidget {
  final AudioTrack? audioTrack;
  final Color color;

  const LocalAudioVisualizer({
    super.key,
    required this.audioTrack,
    this.color = Colors.white,
  });

  @override
  State<LocalAudioVisualizer> createState() => _LocalAudioVisualizerState();
}

class _LocalAudioVisualizerState extends State<LocalAudioVisualizer> {
  static const int sampleCount = 7;
  List<double> samples =
      List.filled(sampleCount, 0.05); // Minimum scale of 0.05
  EventsListener<TrackEvent>? _listener;

  void _startVisualizer(AudioTrack? track) {
    // Clear previous listener
    _stopVisualizer();

    // Reset visualizer immediately for null tracks
    if (track == null) {
      _resetVisualizer();
      return;
    }

    _listener = track.createListener();
    _listener?.on<AudioVisualizerEvent>((e) {
      if (mounted) {
        setState(() {
          samples = e.event
              .take(sampleCount)
              .map((e) => ((e as num).toDouble() * 2).clamp(0.05, 1.0))
              .toList();
          while (samples.length < sampleCount) {
            samples.add(0.05);
          }
        });
      }
    });
  }

  void _resetVisualizer() {
    if (mounted) {
      setState(() {
        samples = List.filled(sampleCount, 0.05);
      });
    }
  }

  @override
  void didUpdateWidget(LocalAudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always call _startVisualizer, which will handle the null case properly
    _startVisualizer(widget.audioTrack);
  }

  void _stopVisualizer() {
    _listener?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startVisualizer(widget.audioTrack);
  }

  @override
  void dispose() {
    _stopVisualizer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Add a SizedBox to constrain the size
      height: 44, // Provide a reasonable height
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            sampleCount,
            (index) => Padding(
              padding: EdgeInsets.only(right: index < sampleCount - 1 ? 3 : 8),
              child: Transform.scale(
                scaleY: index < samples.length
                    ? samples[index]
                    : 0.05, // Safely access samples
                alignment: Alignment.center,
                child: Container(
                  width: 2,
                  height: 36, // Set a fixed height for the base bar
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Audio controls shown when connected
class AudioControls extends StatelessWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomContext, _) {
        final isMicEnabled = roomContext.isMicrophoneEnabled ?? false;
        final micTrack = roomContext.localParticipant
            ?.getTrackPublicationBySource(TrackSource.microphone)
            ?.track as AudioTrack?;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isMicEnabled ? Icons.mic : Icons.mic_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  roomContext.localParticipant
                      ?.setMicrophoneEnabled(!isMicEnabled);
                },
              ),
              LocalAudioVisualizer(
                audioTrack: micTrack,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
