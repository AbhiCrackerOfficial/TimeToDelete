import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  platform: TargetPlatform.android,
  colorSchemeSeed: const Color.fromARGB(255, 122, 76, 61),
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.rubik().fontFamily,
);

final ThemeData darkTheme = ThemeData(
  platform: TargetPlatform.android,
  colorSchemeSeed: const Color.fromARGB(255, 122, 76, 61),
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.rubik().fontFamily,
);