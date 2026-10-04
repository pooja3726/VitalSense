import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color primary = Color(0xFF00BFA6);
  static const Color primaryDark = Color(0xFF008F7A);
  static const Color primaryLight = Color(0xFF64E4D3);

  // Used by health charts and deeper UI accents.
  static const Color deepTeal = Color(0xFF087A6D);

  // ============================================================
  // BACKGROUND
  // ============================================================

  static const Color background = Color(0xFFF4F9F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFEAF7F4);

  // ============================================================
  // TEXT
  // ============================================================

  static const Color textPrimary = Color(0xFF102A2A);
  static const Color textSecondary = Color(0xFF607777);
  static const Color textMuted = Color(0xFF91A4A3);

  // ============================================================
  // STATUS
  // ============================================================

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // ============================================================
  // VITAL COLORS
  // ============================================================

  static const Color heartRate = Color(0xFFE85D75);
  static const Color spo2 = Color(0xFF3B82F6);
  static const Color temperature = Color(0xFFF97316);
  static const Color bloodPressure = Color(0xFF8B5CF6);

  // ============================================================
  // UI
  // ============================================================

  static const Color border = Color(0xFFDCE9E6);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: primaryDark,
          surface: surface,
          error: danger,
        ),

    // ----------------------------------------------------------
    // APP BAR
    // ----------------------------------------------------------
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),

    // ----------------------------------------------------------
    // CARD
    // ----------------------------------------------------------
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: border, width: 1),
      ),
    ),

    // ----------------------------------------------------------
    // TYPOGRAPHY
    // ----------------------------------------------------------
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.6,
      ),

      headlineMedium: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.4,
      ),

      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),

      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),

      bodyLarge: TextStyle(fontSize: 15, color: textPrimary),

      bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.4),

      bodySmall: TextStyle(fontSize: 12, color: textMuted),
    ),

    // ----------------------------------------------------------
    // BUTTON
    // ----------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
