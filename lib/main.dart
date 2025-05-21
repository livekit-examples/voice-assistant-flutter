import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:odelle_nyse/constants/colors.dart';
import 'package:livekit_components/livekit_components.dart'
    show RoomContext, TranscriptionBuilder;
import 'package:provider/provider.dart';
import 'package:odelle_nyse/screens/home_screen.dart';
// import './widgets/control_bar.dart'; // Old, to be removed if unused
// import './services/token_service.dart'; // Old, to be re-evaluated
// import 'widgets/agent_status.dart'; // Old, to be removed if unused
// import 'widgets/transcription_widget.dart'; // Old, to be removed if unused

// Load environment variables before starting the app
// This is used to configure the LiveKit sandbox ID for development
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

// Main app configuration with light/dark theme support
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odelle Nyse',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          surface: AppColors.background, // For Scaffold background
          onPrimary: Colors.white, // Text on primary color
          onSecondary: Colors.white, // Text on secondary color
          onBackground: AppColors.textPrimary, // Text on background color
          onSurface: AppColors.textPrimary, // Text on surface color
          error: Colors.red, // Standard error color
          onError: Colors.white, // Text on error color
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: GoogleFonts.workSans().fontFamily, // Default body font
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w300),
          displayMedium: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w300),
          displaySmall: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
          headlineSmall: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w500), // For AppBar title
          titleLarge: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          bodyLarge: GoogleFonts.workSans(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
          bodyMedium: GoogleFonts.workSans(color: AppColors.textSecondary, fontWeight: FontWeight.w400), // Default text
          labelLarge: GoogleFonts.workSans(color: Colors.white, fontWeight: FontWeight.w500), // For buttons
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background, // Or AppColors.primary if preferred
          elevation: 0, // As per glassmorphic design often prefers flat appbars
          titleTextStyle: GoogleFonts.montserrat(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400, // As per doc: Heading Weights: Light (300) and Regular (400)
            fontSize: 20, // Adjust as needed
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary), // Icons in AppBar
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Changed to HomeScreen
    );
  }
}

// The VoiceAssistant class and _VoiceAssistantState class have been removed.
// Their UI functionality is expected to be covered by VoiceAssistantScreen and
// related widgets.
// RoomContext and TokenService providers will need to be placed appropriately
// in the new widget tree, likely around VoiceAssistantScreen or a shared ancestor
// if other screens also need them.
