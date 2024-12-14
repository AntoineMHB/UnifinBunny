import 'package:flutter/material.dart';

class ColorSchemes {
  static const Color primaryLight = Colors.grey; // Soft, tech-inspired grey
  static const Color secondaryLight = Color(0xFF1E1E1E); // Deep charcoal, modern feel

  static const Color primaryDark = Color(0xFF121212); // Dark, sleek background
  static const Color secondaryDark = Colors.blueGrey; // Dark accent with a hint of blue

  static const Color textLight = Colors.black87; // Readable text on light background
  static const Color textDark = Colors.white; // High contrast text on dark background

  static ColorScheme get lightScheme => const ColorScheme.light(
    primary: primaryLight,
    secondary: secondaryLight,
    onPrimary: textLight,
    onSecondary: primaryLight,
  );

  static ColorScheme get darkScheme => const ColorScheme.dark(
    primary: primaryDark,
    secondary: secondaryDark,
    onPrimary: textDark,
    onSecondary: primaryDark,
  );
}
