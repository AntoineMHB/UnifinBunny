import 'package:flutter/material.dart';

// This is the class to manage the dark mode for an online shoe shopping app
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF1E1E2C), // Rich charcoal background
    primary: const Color(0xFF008080), // Dark teal for branding and accents
    secondary: const Color(0xFFFFA726), // Warm amber for highlights
    tertiary: const Color(0xFF2C2C2C), // Neutral dark gray for subtle elements
    inversePrimary: Colors.grey.shade200, // Soft off-white for contrast
  ),
);
