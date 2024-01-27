import 'package:flutter/material.dart';

final Color purple = hexToColor("#7630fa");
final Color yellow = hexToColor("#f5d547");
final Color black = hexToColor("#121212");

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

String colorToHexColor(Color color) {
  return '#${color.value.toRadixString(16).substring(2)}';
}

MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};

  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

class StyledText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final String? fontFamily;

  const StyledText(
      {super.key,
      required this.text,
      this.color,
      this.size,
      this.fontWeight,
      this.letterSpacing,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily));
  }
}
