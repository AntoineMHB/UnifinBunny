import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white, // Clean background for card surfaces
    primary: Colors.black, // Bold and neutral for primary elements
    secondary: Colors.redAccent, // Eye-catching for secondary elements
    tertiary: Colors.grey.shade200, // Subtle contrast for tertiary surfaces
    inversePrimary: Colors.orangeAccent, // Highlighted text or icons
  ),
);
