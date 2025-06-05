import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart' as components;
import 'package:provider/provider.dart';

import '../controllers/app_ctrl.dart' show AppCtrl;
import '../ui/color_pallette.dart' show LKColorPaletteLight;
import 'floating_glass.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({super.key});

  @override
  Widget build(BuildContext ctx) => FloatingGlassView(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: components.MediaDeviceContextBuilder(
                builder: (context, roomCtx, mediaDeviceCtx) => FloatingGlassButton(
                  icon: mediaDeviceCtx.microphoneOpened ? Icons.mic : Icons.mic_off,
                  subWidget: components.ParticipantSelector(
                    filter: (identifier) => identifier.isAudio && identifier.isLocal,
                    builder: (context, identifier) => SizedBox(
                      width: 15,
                      height: 20,
                      child: components.AudioVisualizerWidget(
                        options: components.AudioVisualizerWidgetOptions(
                          barCount: 5,
                          spacing: 1.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    mediaDeviceCtx.microphoneOpened
                        ? mediaDeviceCtx.disableMicrophone()
                        : mediaDeviceCtx.enableMicrophone();
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FloatingGlassButton(
                icon: Icons.videocam_off,
                onTap: () {},
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FloatingGlassButton(
                icon: Icons.arrow_circle_up,
                onTap: () {},
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FloatingGlassButton(
                icon: Icons.message,
                onTap: () => ctx.read<AppCtrl>().toggleAgentScreenMode(),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FloatingGlassButton(
                iconColor: LKColorPaletteLight().fgModerate,
                icon: Icons.phone_sharp,
                onTap: () => ctx.read<AppCtrl>().disconnect(),
              ),
            ),
          ],
        ),
      );
}
