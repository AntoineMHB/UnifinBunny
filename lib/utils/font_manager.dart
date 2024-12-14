import 'package:flutter/material.dart';

class FontManager {
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Lato';

  static TextStyle get headlineStyle => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 16,
      );
}
