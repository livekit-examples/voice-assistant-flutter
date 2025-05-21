import 'package:flutter/material.dart';
import 'package:odelle_nyse/widgets/voice_assistant_button.dart'; // Placeholder
import 'package:odelle_nyse/constants/colors.dart'; // Placeholder for AppColors
// import 'package:odelle_nyse/widgets/glassmorphic_card.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/hero_journey_card.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/recent_insights_card.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/daily_affirmation_card.dart'; // Placeholder
// import 'package:odelle_nyse/widgets/thought_emotion_behavior_row.dart'; // Placeholder

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent, // From spec, but needs gradient bg
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Odelle Nyse',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'WorkSans', // As per spec for this title
                fontWeight: FontWeight.w300,
              ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background.withOpacity(0.9), // Example
              AppColors.background.withOpacity(0.7), // Example
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              // Placeholder for HeroJourneyCard()
              SizedBox(height: 160, child: Center(child: Text("HeroJourneyCard Placeholder"))),
              SizedBox(height: 16),
              // Placeholder for RecentInsightsCard()
              SizedBox(height: 120, child: Center(child: Text("RecentInsightsCard Placeholder"))),
              SizedBox(height: 16),
              // Placeholder for DailyAffirmationCard()
              SizedBox(height: 120, child: Center(child: Text("DailyAffirmationCard Placeholder"))),
              SizedBox(height: 16),
              // Placeholder for ThoughtEmotionBehaviorRow()
              SizedBox(height: 100, child: Center(child: Text("ThoughtEmotionBehaviorRow Placeholder"))),
            ],
          ),
        ),
      ),
      floatingActionButton: const VoiceAssistantButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
