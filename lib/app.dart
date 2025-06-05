import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/app_ctrl.dart';
import 'screens/agent_screen.dart' show AgentScreen;
import 'ui/color_pallette.dart' show LKColorPaletteLight, LKColorPaletteDark;

import 'screens/welcome_screen.dart';

final appCtrl = AppCtrl();

class VoiceAssistantApp extends StatelessWidget {
  const VoiceAssistantApp({super.key});

  ThemeData buildTheme({required bool isLight}) {
    final colorPallete = isLight ? LKColorPaletteLight() : LKColorPaletteDark();

    return ThemeData(
      useMaterial3: true,
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: colorPallete.fgAccent,
        ),
      ),
      colorScheme: isLight
          ? const ColorScheme.light(
              primary: Colors.black,
              secondary: Colors.black,
              surface: Colors.white,
            )
          : const ColorScheme.dark(
              primary: Colors.white,
              secondary: Colors.white,
              surface: Colors.black,
            ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appCtrl),
          ChangeNotifierProvider.value(value: appCtrl.roomContext),
        ],
        child: MaterialApp(
          title: 'Voice Assistant',
          theme: buildTheme(isLight: true),
          darkTheme: buildTheme(isLight: false),
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (ctx) {
              final appCtrl = ctx.watch<AppCtrl>();
              switch (appCtrl.screen) {
                case AppScreen.welcome:
                  return const WelcomeScreen();
                case AppScreen.agent:
                  return const AgentScreen();
              }
            },
          ),
        ),
      );
}
