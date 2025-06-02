import 'package:flutter/material.dart';

abstract class AppColorPalette {
  // FG
  Color get fg0;
  Color get fg1;
  Color get fg2;
  Color get fg3;
  Color get fg4;
  Color get fgSerious;
  Color get fgSuccess;
  Color get fgModerate;
  Color get fgAccent;

  // BG
  Color get bg1;
  Color get bg2;
  Color get bg3;
  Color get bgSerious;
  Color get bgSuccess;
  Color get bgModerate;
  Color get bgAccent;

  // Separator
  Color get separator1;
  Color get separator2;
  Color get separatorForSerious;
  Color get separatorForSuccess;
  Color get separatorModerate;
  Color get separatorAccent;
}

class LKColorPaletteDark implements AppColorPalette {
  //FG
  @override
  Color get fg0 => const Color(0xFF000000);

  @override
  Color get fg1 => const Color(0xFFCCCCCC);

  @override
  Color get fg2 => const Color(0xFFB2B2B2);

  @override
  Color get fg3 => const Color(0xFF999999);

  @override
  Color get fg4 => const Color(0xFF666666);

  @override
  Color get fgSerious => const Color(0xFFFF7566);

  @override
  Color get fgSuccess => const Color(0xFF3BC981);

  @override
  Color get fgModerate => const Color(0xFFF7B752);

  @override
  Color get fgAccent => const Color(0xFF002CF2);

  // BG
  @override
  Color get bg1 => const Color(0xFF070707);

  @override
  Color get bg2 => const Color(0xFF131313);

  @override
  Color get bg3 => const Color(0xFF202020);

  @override
  Color get bgSerious => const Color(0xFF1F0E0B);

  @override
  Color get bgSuccess => const Color(0xFF001905);

  @override
  Color get bgModerate => const Color(0xFF1A0E04);

  @override
  Color get bgAccent => const Color(0xFF090C17);

  // Separator
  @override
  Color get separator1 => const Color(0xFF202020);

  @override
  Color get separator2 => const Color(0xFF30302F);

  @override
  Color get separatorForSerious => const Color(0xFF5A1C16);

  @override
  Color get separatorForSuccess => const Color(0xFF003213);

  @override
  Color get separatorModerate => const Color(0xFF3F2208);

  @override
  Color get separatorAccent => const Color(0xFF0C1640);
}

class LKColorPaletteLight implements AppColorPalette {
  //FG
  @override
  Color get fg0 => const Color(0xFFFFFFFF);

  @override
  Color get fg1 => const Color(0xFF3B3B3B);

  @override
  Color get fg2 => const Color(0xFF4D4D4D);

  @override
  Color get fg3 => const Color(0xFF636363);

  @override
  Color get fg4 => const Color(0xFF707070);

  @override
  Color get fgSerious => const Color(0xFFDB1B06);

  @override
  Color get fgSuccess => const Color(0xFF006430);

  @override
  Color get fgModerate => const Color(0xFFA65006);

  @override
  Color get fgAccent => const Color(0xFF002CF2);

  // BG
  @override
  Color get bg1 => const Color(0xFFDBDBD8);

  @override
  Color get bg2 => const Color(0xFFF3F3F1);

  @override
  Color get bg3 => const Color(0xFFE2E2DF);

  @override
  Color get bgSerious => const Color(0xFFFAE6E6);

  @override
  Color get bgSuccess => const Color(0xFFD1FADF);

  @override
  Color get bgModerate => const Color(0xFFFAEDD1);

  @override
  Color get bgAccent => const Color(0xFFB3CCFF);

  // Separator
  @override
  Color get separator1 => const Color(0xFFDBDBD8);

  @override
  Color get separator2 => const Color(0xFFBDBDBB);

  @override
  Color get separatorForSerious => const Color(0xFFFFCDC7);

  @override
  Color get separatorForSuccess => const Color(0xFF94DCB5);

  @override
  Color get separatorModerate => const Color(0xFFFBD7A0);

  @override
  Color get separatorAccent => const Color(0xFFB3CCFF);
}
