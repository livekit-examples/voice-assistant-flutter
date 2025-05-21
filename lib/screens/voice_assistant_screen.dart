import 'package:flutter/material.dart';
import 'package:odelle_nyse/constants/colors.dart'; // Placeholder for AppColors
// import 'package:odelle_nyse/widgets/audio_waveform_visualizer.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/transcription_view.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/voice_control_bar.dart'; // Placeholder

class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent, // From spec
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background.withOpacity(0.9),
              AppColors.background.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: const [
              Expanded(
                flex: 1,
                // child: AudioWaveformVisualizer(), // Placeholder
                child: Center(child: Text("AudioWaveformVisualizer Placeholder")),
              ),
              Expanded(
                flex: 2,
                // child: TranscriptionView(), // Placeholder
                child: Center(child: Text("TranscriptionView Placeholder")),
              ),
              // VoiceControlBar(), // Placeholder
              SizedBox(height: 80, child: Center(child: Text("VoiceControlBar Placeholder"))),
            ],
          ),
        ),
      ),
    );
  }
}
