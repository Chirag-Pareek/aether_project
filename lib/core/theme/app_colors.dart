import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  // Panel & UI
  static const Color panelBackground = Color(0xFFF3E2B6);
  static const Color panelBorder = Color(0xFFB57028);
  static const Color panelInnerBorder = Color(0xFFDEC594);
  
  // Text
  static const Color textPrimary = Color(0xFF382A1B);
  static const Color textAccent = Color(0xFFD94522); // Timer red
  
  // Buttons
  static const Color buttonBg = Color(0xFFF6B924);
  static const Color buttonBorder = Color(0xFF8F581A);
  static const Color buttonHighlight = Color(0xFFFFD459);
  static const Color buttonShadow = Color(0xFFC7881C);

  // Slots
  static const Color slotBg = Color(0xFFE2CC9C);
  static const Color slotBorder = Color(0xFF90591E);
  static const Color slotFilled = Color(0xFF75B326);

  // Chat
  static const Color chatBg = Color(0xFFF3E2B6);
  static const Color chatInputBg = Color(0xFFE2CC9C);
  
  // Backwards compatibility for existing code (until refactored)
  static const Color primary = textPrimary;
  static const Color onPrimary = panelBackground;
  static const Color canvas = panelBackground;
  static const Color semanticSuccess = slotFilled;
  static const Color semanticError = textAccent;
  static const Color hairlineSoft = panelBorder;
  static const Color surfaceStrong = slotBg;
  static const Color onDarkSoft = textPrimary;
  static const Color ink = textPrimary;
  
  static AppColors of(BuildContext context) => const AppColors();
}
