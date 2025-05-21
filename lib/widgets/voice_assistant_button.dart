import 'package:flutter/material.dart';
import 'package:odelle_nyse/screens/voice_assistant_screen.dart';
import 'package:odelle_nyse/constants/colors.dart';

class VoiceAssistantButton extends StatelessWidget {
  const VoiceAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VoiceAssistantScreen()),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary, // #8ECAE6
              AppColors.secondary, // #219EBC
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3), // #219EBC
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
