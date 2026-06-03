// lib/config/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A0E1A);
  static const Color secondary = Color(0xFF121829);
  static const Color accent = Color(0xFFE31837);
  static const Color accentGold = Color(0xFFFFB800);
  static const Color cardBg = Color(0xFF1A2235);
  static const Color cardBorder = Color(0xFF2A3550);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A9BB8);
  static const Color liveDot = Color(0xFF00E676);
  static const Color gradientStart = Color(0xFF0A0E1A);
  static const Color gradientEnd = Color(0xFF1A2235);
  static const Color drawerBg = Color(0xFF0D1220);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentGold,
        surface: AppColors.cardBg,
        background: AppColors.primary,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Rajdhani',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 1.0,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.drawerBg,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
        ),
      ),
      dividerColor: AppColors.cardBorder,
      useMaterial3: true,
    );
  }
}

class AppConstants {
  static const String appName = 'TEN SPORTS HD';
  static const String appVersion = '1.0.0';
  static const String contactEmail = 'sultanprince025@gmail.com';
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String shareMessage =
      'Watch live sports in HD! Download TEN SPORTS HD app now.\nhttps://play.google.com/store/apps/details?id=com.tensportshd';
}
