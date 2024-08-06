import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  textTheme: GoogleFonts.interTextTheme(
    TextTheme(
      displayLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.inter(fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
      //--------------
      headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w600),
      headlineSmall:
          GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 24),
      //--------------
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w400),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
      //--------------
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium: GoogleFonts.inter(fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
      //--------------
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
      bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400, fontSize: 14, letterSpacing: 0.25),
      bodySmall: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12),
    ),
  ),
);
