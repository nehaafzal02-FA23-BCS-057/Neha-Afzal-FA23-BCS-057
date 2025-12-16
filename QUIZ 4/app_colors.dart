import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient Colors (Orange to Pink - Sunset)
  static const Color primaryStart = Color(0xFFFF6B35);
  static const Color primaryEnd = Color(0xFFF7296E);

  // Secondary Gradient Colors (Orange to Pink - Sunset)
  static const Color secondaryStart = Color(0xFFFF6B35);
  static const Color secondaryEnd = Color(0xFFF7296E);

  // Accent Gradient Colors (Orange to Red)
  static const Color accentStart = Color(0xFFFF8C42);
  static const Color accentEnd = Color(0xFFF7296E);

  // Button Gradient
  static const Color buttonStart = Color(0xFFFF6B35);
  static const Color buttonEnd = Color(0xFFF7296E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF7FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Error Color
  static const Color errorColor = Color(0xFFF56565);
  static const Color successColor = Color(0xFF48BB78);

  // Gradients
  static LinearGradient mainGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryStart, primaryEnd],
  );

  static LinearGradient secondaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryStart, secondaryEnd],
  );

  static LinearGradient accentGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentStart, accentEnd],
  );

  static LinearGradient buttonGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [buttonStart, buttonEnd],
  );

  static LinearGradient backgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFF7296E),
      Color(0xFF9D4EDD),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
