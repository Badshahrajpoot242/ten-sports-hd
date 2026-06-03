// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color primaryRed = Color(0xFFE53935);
  static const Color deepRed = Color(0xFFB71C1C);
  static const Color accentGold = Color(0xFFFFD600);
  static const Color darkBg = Color(0xFF0A0A0F);
  static const Color cardBg = Color(0xFF141420);
  static const Color surfaceBg = Color(0xFF1C1C2A);
  static const Color dividerColor = Color(0xFF2A2A3A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textMuted = Color(0xFF606070);
  static const Color liveBadge = Color(0xFFFF1744);
  static const Color onlineGreen = Color(0xFF00E676);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: primaryRed,
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        secondary: accentGold,
        surface: cardBg,
        background: darkBg,
        error: Color(0xFFFF5252),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          fontFamily: 'AppFont',
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: cardBg,
        elevation: 16,
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFamily: 'AppFont',
          letterSpacing: 1.2,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'AppFont',
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        bodyLarge: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 12,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryRed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceBg,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
