import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart'
    hide ParticipantKind;
import 'package:provider/provider.dart';

/// Shows a visualizer for the agent participant in the room
/// This widget:
/// 1. Finds the agent participant in the room
/// 2. Listens to their audio track
/// 3. Shows a waveform visualization of their audio
/// 4. Adjusts opacity based on agent state (speaking/thinking/listening)
class StatusWidget extends StatefulWidget {
  const StatusWidget({
    super.key,
  });

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomContext, child) {
        // Find the agent participant in the room
        // LiveKit supports different participant types (agent/client/subscriber)
        // We only care about the agent participant here
        return ChangeNotifierProvider.value(
          value: roomContext.room.remoteParticipants.values
              .where((p) => p.kind == ParticipantKind.AGENT)
              .firstOrNull,
          child: Consumer<RemoteParticipant?>(
            builder: (context, agentParticipant, child) {
              // If no agent participant yet, show nothing
              if (agentParticipant == null) {
                return const SizedBox.shrink();
              }

              // Listen to the agent's metadata attributes
              // These include the agent's state (speaking/thinking/listening)
              return ChangeNotifierProvider(
                create: (context) => ParticipantContext(agentParticipant),
                child: ParticipantAttributes(
                  builder: (context, attributes) {
                    // Get the agent's state from their metadata
                    // LiveKit uses a 'lk.agent.state' attribute to track this
                    final agentState = AgentState.fromString(
                        attributes?['lk.agent.state'] ?? 'initializing');

                    // Get the agent's audio track for visualization
                    final audioTrack = agentParticipant.audioTrackPublications
                        .firstOrNull?.track as AudioTrack?;

                    // If no audio track yet, show nothing
                    if (audioTrack == null) {
                      return const SizedBox.shrink();
                    }

                    // Show the waveform with opacity based on agent state
                    return _AnimatedOpacityWidget(
                      agentState: agentState,
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

/// Helper widget to animate the opacity of the waveform
/// based on the agent's current state
class _AnimatedOpacityWidget extends StatefulWidget {
  final AgentState agentState;
  final Widget child;

  const _AnimatedOpacityWidget({
    required this.agentState,
    required this.child,
  });

  @override
  State<_AnimatedOpacityWidget> createState() => _AnimatedOpacityWidgetState();
}

class _AnimatedOpacityWidgetState extends State<_AnimatedOpacityWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Different states have different animation durations
  Duration _getDuration() {
    switch (widget.agentState) {
      case AgentState.thinking:
        return const Duration(
            milliseconds: 500); // Faster animation for thinking
      default:
        return const Duration(
            milliseconds: 1000); // Default duration for other states
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getDuration(),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_AnimatedOpacityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agentState != widget.agentState) {
      _controller.duration = _getDuration();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Different states have different opacity ranges
  double _getOpacity() {
    switch (widget.agentState) {
      case AgentState.initializing:
        return 0.3; // Dim when starting
      case AgentState.speaking:
        return 1.0; // Fully visible when speaking
      case AgentState.thinking:
        return 0.3 + (0.5 * _controller.value); // Pulsing when thinking
      case AgentState.listening:
        return 0.3 + (0.5 * _controller.value); // Pulsing when listening
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _getOpacity(),
        child: child,
      ),
      child: widget.child,
    );
  }
}
