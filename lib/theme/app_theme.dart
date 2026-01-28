import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _brandYellow = Color(0xFFF6C90E);
  static const _inkBlack = Color(0xFF111217);
  static const _softGray = Color(0xFFF5F6FA);
  static const _cardBorder = Color(0xFFE8EAF1);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: _inkBlack,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: _inkBlack,
      ),
      bodyLarge: GoogleFonts.manrope(color: const Color(0xFF1F1F21)),
      bodyMedium: GoogleFonts.manrope(color: const Color(0xFF3A3C40)),
    );

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _brandYellow,
        primary: _brandYellow,
        secondary: _inkBlack,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: _softGray,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: _inkBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: _inkBlack,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _cardBorder),
        ),
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandYellow,
          foregroundColor: _inkBlack,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _inkBlack, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _inkBlack,
        unselectedItemColor: Color(0xFF9AA0AA),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFF1F3F7),
        selectedColor: _brandYellow,
        labelStyle: const TextStyle(color: _inkBlack),
      ),
    );
  }
}
