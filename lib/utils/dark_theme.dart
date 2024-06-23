import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/utils/constutils.dart';

ThemeData darkTheme() => ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: ColorPaletteLight.kColorBlue,
        secondary: ColorPaletteLight.kColorBlue,
        shadow: ColorPaletteLight.kColorGrayLight,
        onSurface: ColorPaletteLight.kBackElevated,
        surface: ColorPaletteLight.kBackPrimary,
      ),
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorPaletteLight.kBackPrimary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      scaffoldBackgroundColor: ColorPaletteLight.kBackPrimary,
      primaryColor: ColorPaletteLight.kColorBlue,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: ColorPaletteLight.kLabelPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 32,
            height: 38 / 32,
          ),
        ),
        titleMedium: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: ColorPaletteLight.kLabelPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            height: 32 / 20,
          ),
        ),
        bodyMedium: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: ColorPaletteLight.kLabelPrimary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 20 / 16,
          ),
        ),
        bodySmall: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: ColorPaletteLight.kLabelPrimary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 20 / 14,
          ),
        ),
        labelLarge: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: ColorPaletteLight.kLabelPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 24 / 14,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: ColorPaletteLight.kColorBlue.withOpacity(0.3),
        selectionHandleColor: ColorPaletteLight.kColorBlue,
      ),
      iconTheme: const IconThemeData(color: ColorPaletteLight.kLabelTertiary),
    );
