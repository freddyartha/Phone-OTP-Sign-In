import 'package:flutter/material.dart';

class MahasColors {
  static const Color blue = Color(0xFF3aa4aa);
  static const Color red = Color(0xFFC62828);
  static const Color yellow = Color(0xFFD84315);
  static const Color violet = Color(0xFF6A1B9A);
  static const Color brown = Color(0xFFA66E68);
  static const Color cream = Color(0xFFF2C094);
  static Color grey = MahasColors.dark.withOpacity(.5);
  static Color green = Colors.green.shade600;

  static List<Color> grafikColors = [
    brown,
    yellow,
    blue,
    cream,
    red,
    grey,
  ];

  static const Color primary = blue;
  static const Color light = Colors.white;
  static const Color dark = Colors.black;
  static const Color danger = red;
  static const Color warning = yellow;

  static BoxDecoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        MahasColors.cream.withOpacity(.8),
        MahasColors.cream,
      ],
    ),
  );
}
