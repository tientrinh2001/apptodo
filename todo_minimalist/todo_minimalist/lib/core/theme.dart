import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = FlexThemeData.dark(
  fontFamily: GoogleFonts.lato().fontFamily,
  scheme: FlexScheme.aquaBlue,
);
ThemeData lightTheme = FlexThemeData.light(
  fontFamily: GoogleFonts.lato().fontFamily,
  scheme: FlexScheme.aquaBlue,
);

TextStyle get titleStyle {
  return GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold);
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(fontSize: 12);
}
