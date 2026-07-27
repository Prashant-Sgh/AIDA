import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFF2C2C2C);
  static const Color background = Colors.white;
  static const Color text = Colors.black;
  static const Color dropDownLine = Color(0xFFDAEEFF);
  static const Color line = Color(0xFFB3B3B3);
  static const Color lightCard = Color(0xFFF5F5F5);

  // Dark theme colors
  static const Color primaryDark = Color(0xFFFFFFFF);
  static const Color secondaryDark = Color(0xFFC9C9C9);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color textDark = Colors.white;
  static const Color dropDownLineDark = Color(0xFF2A9BFF);
  static const Color lineDark = Color(0xFF404040);
  static const Color lightCardDark = Color(0xFF1A1A1A);

  // Context screen colors
  static const Color contextScrBackground = Color(0xFF2D2D2D);
  static const Color contextScrCard = Color(0xFF222222);
  static const Color contextScrCardStroke = Color(0xFF484848);
  static const Color contextScrExpandedCard = Color(0xFF373737);
  static const Color contextScrExpandedCardTxtField = Color(0xFF2A2A2A);
  static const Color contextScrButtonClearTxt = Color(0xFF3F3F3F);

  // Light theme colors (Inspired by the Dark Context Screen colors)
  static const Color contextScrBackgroundLight =
      Color(0xFFF9F9F9); // Clean off-white background
  static const Color contextScrCardLight =
      Color(0xFFFFFFFF); // Pure white for primary cards
  static const Color contextScrCardStrokeLight =
      Color(0xFFE0E0E0); // Soft light-gray border
  static const Color contextScrExpandedCardLight =
      Color(0xFFF0F0F0); // Slightly darker gray for depth
  static const Color contextScrExpandedCardTxtFieldLight = Color(0xFFDEDEDE);
  static const Color contextScrButtonClearTxtLight =
      Color(0xFFB0B0B0); // Muted gray text for secondary actions
}
