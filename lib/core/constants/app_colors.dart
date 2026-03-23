import 'package:flutter/material.dart';

class AppColors {
  // Primary Premium Colors
  static const Color primaryLight = Color(0xFF6F35A5);
  static const Color primaryDark = Color(0xFFA573FF);
  static const Color accent = Color(0xFF00D2FF);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6F35A5), Color(0xFF8B2387), Color(0xFFE94057)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F2F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF2C2D35), Color(0xFF1E1F25)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFF4F6F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Neutrals
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF5F6368);
  
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);

  // Status colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  
  // Score colors
  static const Color scoreLow = Color(0xFFFF1744);
  static const Color scoreMedium = Color(0xFFFFAB00);
  static const Color scoreHigh = Color(0xFF00E676);
}
