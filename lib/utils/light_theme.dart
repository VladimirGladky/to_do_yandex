import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/utils/constutils.dart';

ThemeData lightTheme() => ThemeData(
      colorScheme: const ColorScheme.light(
        primary: ColorPaletteLight.kColorBlue,
        secondary: ColorPaletteLight.kColorGray,
        shadow: ColorPaletteLight.kColorGrayLight,
        onSurface: ColorPaletteLight.kBackElevated,
        surface: ColorPaletteLight.kBackPrimary,
      ),
      brightness: Brightness.light,
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
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: ColorPaletteLight.kColorBlue,
        selectionHandleColor: ColorPaletteLight.kColorBlue,
      ),
      iconTheme: const IconThemeData(color: ColorPaletteLight.kLabelTertiary),
      useMaterial3: false,
    );
