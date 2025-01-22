import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as livekit show ConnectionState;
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import '../services/token_service.dart';
import 'package:livekit_components/livekit_components.dart';

// Configuration states based on connection status
enum Configuration { disconnected, connected, transitioning }

/// The ControlBar component handles connection, disconnection, and audio controls
/// You can customize this component to fit your app's needs
class ControlBar extends StatefulWidget {
  const ControlBar({super.key});

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  bool isConnecting = false;
  bool isDisconnecting = false;

  Configuration get currentConfiguration {
    if (isConnecting || isDisconnecting) {
      return Configuration.transitioning;
    }
    
    final roomContext = context.read<RoomContext>();
    if (roomContext.room.connectionState == livekit.ConnectionState.disconnected) {
      return Configuration.disconnected;
    } else {
      return Configuration.connected;
    }
  }

  Future<void> connect() async {
    final roomContext = context.read<RoomContext>();
    final tokenService = context.read<TokenService>();
    
    setState(() {
      isConnecting = true;
    });

    try {
      // Generate random room and participant names
      final roomName = 'room-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';
      final participantName = 'user-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';

      final connectionDetails = await tokenService.fetchConnectionDetails(
        roomName: roomName,
        participantName: participantName,
      );

      if (connectionDetails == null) {
        throw Exception('Failed to get connection details');
      }

      await roomContext.connect(
        url: connectionDetails.serverUrl,
        token: connectionDetails.participantToken,
      );
      await roomContext.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      print('Connection error: $error');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

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
                  AudioControls(),
                  const SizedBox(width: 16),
                  DisconnectButton(onPressed: disconnect),
                ],
              );
              
            case Configuration.transitioning:
              return TransitionButton(
                isConnecting: isConnecting
              );
          }
        }),
        
        const Spacer(),
      ],
    );
  }
}

// /// Displays real-time audio levels for the local participant
// class LocalAudioVisualizer extends StatefulWidget {
//   final AudioTrack? track;

//   const LocalAudioVisualizer({super.key, this.track});

//   @override
//   State<LocalAudioVisualizer> createState() => _LocalAudioVisualizerState();
// }

// class _LocalAudioVisualizerState extends State<LocalAudioVisualizer> {
//   late AudioProcessor audioProcessor;

//   @override
//   void initState() {
//     super.initState();
//     audioProcessor = AudioProcessor(
//       track: widget.track,
//       bandCount: 9,
//       isCentered: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HStack(
//       spacing: 3,
//       children: [
//         for (int index = 0; index < 9; index++)
//           Rectangle(
//             fill: Color.primary,
//             frame: Rect(0, 0, 2, double.infinity),
//             alignment: Alignment.center,
//             scale: Scale(
//               x: 1,
//               y: max(0.05, audioProcessor.bands[index]),
//               anchor: Anchor(x: 0.5, y: 0.5),
//             ),
//           ),
//       ],
//       padding: EdgeInsets(vertical: 8, leading: 0, trailing: 8),
//     );
//   }
// }

/// Button shown when disconnected to start a new conversation
class ConnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConnectButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'START CONVERSATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
    return ElevatedButton(
      onPressed: null, // Disabled during transition
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          isConnecting ? 'CONNECTING...' : 'DISCONNECTING...',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
    final roomContext = context.watch<RoomContext>();
    final isMicEnabled = roomContext.localParticipant?.isMicrophoneEnabled() ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          isMicEnabled ? Icons.mic : Icons.mic_off,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          roomContext.localParticipant?.setMicrophoneEnabled(!isMicEnabled);
        },
      ),
    );
  }
}
