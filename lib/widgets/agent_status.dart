import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';

/// Shows a visualizer for the agent participant in the room
/// This widget:
/// 1. Finds the agent participant in the room
/// 2. Listens to their audio track
/// 3. Shows a waveform visualization of their audio
/// 4. Adjusts opacity based on agent state (speaking/thinking/listening)
class AgentStatusWidget extends StatefulWidget {
  const AgentStatusWidget({
    super.key,
  });

  @override
  State<AgentStatusWidget> createState() => _AgentStatusWidgetState();
}

class _AgentStatusWidgetState extends State<AgentStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return ParticipantSelector(
      filter: (identifier) =>
          identifier.isAudio && !identifier.isLocal /*&& identifier.isAgent*/,
      builder: (context, identifier) {
        return SizedBox(
          height: 320,
          child: AudioVisualizerWidget(
            noTrackWidget: const SizedBox.shrink(),
            options: AudioVisualizerWidgetOptions(
              width: 32,
              minHeight: 32,
              maxHeight: 320,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}

/// Possible states for the agent participant
/// These states are set by the agent and sent via LiveKit metadata
enum AgentState {
  initializing, // Agent is starting up
  speaking, // Agent is speaking to the user
  thinking, // Agent is processing user input
  listening; // Agent is listening to user audio

  static AgentState fromString(String value) {
    return AgentState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => AgentState.initializing,
    );
  }
}
