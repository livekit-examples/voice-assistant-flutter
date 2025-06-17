import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as sdk;
import 'package:livekit_components/livekit_components.dart' as components;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import '../exts.dart';
import '../support/agent_selector.dart';
import 'camera_toggle_button.dart';
import 'control_bar.dart';

class AgentLayoutSwitcher extends StatelessWidget {
  final bool isFullVisualizer;
  //
  final Widget Function(BuildContext ctx) transcriptionsBuilder;
  final Widget Function(BuildContext ctx) agentViewBuilder;

  final Duration animationDuration;
  final Curve animationCurve;

  const AgentLayoutSwitcher({
    super.key,
    this.isFullVisualizer = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutSine,
    required this.transcriptionsBuilder,
    required this.agentViewBuilder,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (ctx, constraints) => Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 110),
                child: transcriptionsBuilder(context),
              ),
            ),
            Positioned.fill(
              child: AnimatedPadding(
                curve: animationCurve,
                duration: animationDuration,
                padding: EdgeInsets.only(
                  top: isFullVisualizer ? 0.0 : MediaQuery.of(ctx).viewPadding.top,
                  bottom: isFullVisualizer ? 0.0 : (constraints.maxHeight * 0.7),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: agentViewBuilder(ctx),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: max(20, MediaQuery.of(ctx).viewPadding.bottom),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    IgnorePointer(
                      ignoring: !isFullVisualizer,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: components.MediaDeviceContextBuilder(
                          builder: (context, roomCtx, mediaDeviceCtx) => AnimatedOpacity(
                            opacity: (mediaDeviceCtx.cameraOpened && isFullVisualizer) ? 1.0 : 0.0,
                            duration: animationDuration,
                            curve: animationCurve,
                            child: Container(
                              height: 180,
                              width: 120,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: components.ParticipantSelector(
                                filter: (identifier) => identifier.isVideo && identifier.isLocal,
                                builder: (context, identifier) => Stack(
                                  children: [
                                    const components.VideoTrackWidget(
                                      fit: sdk.VideoViewFit.cover,
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: CameraToggleButton(
                                        onTap: () => mediaDeviceCtx.toggleCameraPosition(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: AgentParticipantSelector(
                        builder: (ctx, agentParticipant) => Selector<components.ParticipantContext?, bool>(
                          selector: (ctx, agentCtx) =>
                              agentCtx?.agentState == components.AgentState.initializing ||
                              agentCtx?.agentState == components.AgentState.listening,
                          builder: (ctx, isListening, child) => AnimatedOpacity(
                            opacity: isFullVisualizer && isListening ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutSine,
                            child: shimmer.Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.white,
                              child: const Text(
                                "Agent is listening, start talking",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const ControlBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
