import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
        primaryColor: primaryLight,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.light(
          primary: primaryLight,
          secondary: accentColor,
          surface: cardBackground,
          background: backgroundColor,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.light().textTheme.copyWith(
                displayLarge: const TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                displayMedium: const TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                displaySmall: const TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                headlineMedium: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                titleMedium: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                bodyLarge: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
                bodyMedium: const TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: white),
          titleTextStyle: TextStyle(
            color: white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: primaryDark,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryLight,
            foregroundColor: primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
} 