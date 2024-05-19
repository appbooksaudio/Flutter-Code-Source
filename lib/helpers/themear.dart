import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeLightAr = ThemeData(
  brightness: Brightness.light,
  primaryIconTheme: const IconThemeData(
    color: ColorLight.fontTitle,
    size: 20,
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: ColorLight.primary,
    onPrimary: ColorLight.primary,
    secondary: ColorLight.secondary,
    onSecondary: ColorLight.secondary,
    error: ColorLight.error,
    onError: ColorLight.error,
    background: ColorLight.background,
    onBackground: ColorLight.background,
    surface: ColorLight.background,
    onSurface: ColorLight.background,
  ),
  primaryColor: ColorLight.primary,
  cardColor: ColorLight.card,
  disabledColor: ColorLight.disabled,
  hintColor: ColorLight.hint,
  indicatorColor: ColorLight.primary,
  buttonTheme: ButtonThemeData(
    disabledColor: ColorLight.disabledButton,
    buttonColor: ColorLight.primary,
    height: 45,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Const.radius),
    ),
  ),
  iconTheme: const IconThemeData(color: ColorLight.fontTitle),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: ColorLight.primary,
  ),
  scaffoldBackgroundColor: ColorLight.background,
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme: GoogleFonts.cairoTextTheme().copyWith(
    headlineLarge: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: GoogleFonts.cairo(
      color: ColorLight.fontTitle,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: GoogleFonts.cairo(
      color: ColorLight.fontSubtitle,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.cairo(
      color: ColorLight.fontSubtitle,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.cairo(
      color: ColorLight.fontSubtitle,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
);

ThemeData themeDarkAr = ThemeData(
  brightness: Brightness.dark,
  primaryIconTheme: const IconThemeData(
    color: ColorDark.fontTitle,
    size: 20,
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: ColorDark.primary,
    onPrimary: ColorDark.primary,
    secondary: ColorDark.secondary,
    onSecondary: ColorDark.secondary,
    error: ColorDark.error,
    onError: ColorDark.error,
    background: ColorDark.background,
    onBackground: ColorDark.background,
    surface: ColorDark.background,
    onSurface: ColorDark.background,
  ),
  primaryColor: ColorDark.primary,
  cardColor: ColorDark.card,
  disabledColor: ColorDark.disabled,
  hintColor: ColorDark.hint,
  indicatorColor: ColorDark.primary,
  buttonTheme: ButtonThemeData(
    disabledColor: ColorDark.disabledButton,
    buttonColor: ColorDark.primary,
    height: 45,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Const.radius),
    ),
  ),
  iconTheme: const IconThemeData(color: ColorDark.fontTitle),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: ColorDark.primary,
  ),
  scaffoldBackgroundColor: ColorDark.background,
  appBarTheme: const AppBarTheme(
    color: ColorDark.background,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme: GoogleFonts.cairoTextTheme().copyWith(
    headlineLarge: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.cairo(
      color: ColorDark.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: GoogleFonts.cairo(
      color: ColorDark.fontTitle,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: GoogleFonts.cairo(
      color: ColorDark.fontSubtitle,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.cairo(
      color: ColorDark.fontSubtitle,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.cairo(
      color: ColorDark.fontSubtitle,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
);
