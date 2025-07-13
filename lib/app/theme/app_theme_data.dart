import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  splashColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.bgOrange800,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.darkColor,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: AppColors.bgOrange600,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.black45,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color:Colors.black45,
    ),
    labelSmall: GoogleFonts.montserrat(
      color: AppColors.accentOrange400,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  splashColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
    labelSmall: GoogleFonts.montserrat(
      color: AppColors.accentOrange400,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  ),
);
