import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart' hide ParticipantKind;
import 'package:provider/provider.dart';

/// Shows a visualizer for the agent participant in the room
/// In a more complex app, you may want to show more information here
class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomContext, child) {
        // Find the agent participant
        RemoteParticipant? agentParticipant = roomContext.room.remoteParticipants.values
            .where((p) => p.kind == ParticipantKind.AGENT)
            .firstOrNull;

        // If no agent participant yet, show nothing    
        if (agentParticipant == null) {
          return const SizedBox.shrink();
        }

        return ChangeNotifierProvider(
          create: (context) => ParticipantContext(agentParticipant),
          child: ParticipantAttributes(
            builder: (context, attributes) {
              final agentState = AgentState.fromString(
                attributes?['lk.agent.state'] ?? 'initializing'
              );

              final audioTrack = agentParticipant.audioTrackPublications.firstOrNull?.track as AudioTrack?;

              // If no audio track yet, show nothing
              if (audioTrack == null) {
                return const SizedBox.shrink();
              }

              return AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: agentState == AgentState.speaking ? 1.0 : 0.3,
                child: SoundWaveformWidget(
                  audioTrack: audioTrack,
                  options: AudioVisualizerOptions(
                    width: 32,
                    minHeight: 32,
                    maxHeight: 256,
                    color: Theme.of(context).colorScheme.primary,
                    count: 7,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

enum AgentState {
  initializing,
  speaking, 
  thinking;

  static AgentState fromString(String value) {
    return AgentState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => AgentState.initializing,
    );
  }
}
