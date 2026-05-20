import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final _fontFamily = GoogleFonts.cairo().fontFamily!;

  // ── Light Theme ────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.info,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.lightBg,

    // AppBar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.lightBg,
      foregroundColor: AppColors.lightInk,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.lightInk,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.lightSubtext, fontSize: 15),
    ),

    // BottomNav
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontFamily: _fontFamily,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          );
        }
        return TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.lightSubtext,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 24);
        }
        return const IconThemeData(color: AppColors.lightSubtext, size: 22);
      }),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightBg,
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600),
      side: const BorderSide(color: AppColors.lightBorder),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 0,
    ),

    // Text
    textTheme: TextTheme(
      displayLarge:  TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w900, color: AppColors.lightInk),
      displayMedium: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.lightInk),
      headlineLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.lightInk),
      headlineMedium:TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.lightInk),
      headlineSmall: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.lightInk),
      titleLarge:    TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700, color: AppColors.lightInk),
      titleMedium:   TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, color: AppColors.lightInk),
      bodyLarge:     TextStyle(fontFamily: _fontFamily, color: AppColors.lightInk),
      bodyMedium:    TextStyle(fontFamily: _fontFamily, color: AppColors.lightInk),
      bodySmall:     TextStyle(fontFamily: _fontFamily, color: AppColors.lightSubtext),
    ),
  );

  // ── Dark Theme ─────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.info,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.darkBg,
      foregroundColor: AppColors.darkInk,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.darkInk,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.darkSubtext, fontSize: 15),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(fontFamily: _fontFamily, color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 12);
        }
        return TextStyle(fontFamily: _fontFamily, color: AppColors.darkSubtext, fontWeight: FontWeight.w500, fontSize: 12);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primaryLight, size: 24);
        }
        return const IconThemeData(color: AppColors.darkSubtext, size: 22);
      }),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600),
      side: const BorderSide(color: AppColors.darkBorder),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1, space: 0),

    textTheme: TextTheme(
      displayLarge:  TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w900, color: AppColors.darkInk),
      displayMedium: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.darkInk),
      headlineLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.darkInk),
      headlineMedium:TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.darkInk),
      headlineSmall: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, color: AppColors.darkInk),
      titleLarge:    TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700, color: AppColors.darkInk),
      titleMedium:   TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, color: AppColors.darkInk),
      bodyLarge:     TextStyle(fontFamily: _fontFamily, color: AppColors.darkInk),
      bodyMedium:    TextStyle(fontFamily: _fontFamily, color: AppColors.darkInk),
      bodySmall:     TextStyle(fontFamily: _fontFamily, color: AppColors.darkSubtext),
    ),
  );
}
