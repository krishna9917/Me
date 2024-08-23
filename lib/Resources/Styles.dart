import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle normalText({
    required BuildContext context,
    double fontSize = 14,
    Color? color,
    bool isBold = false,
  }) {
    // Retrieve the current theme from the context
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final isGoldenTheme = Theme.of(context).primaryColor == Colors.amber;

    // Set the default color based on the theme
    Color defaultColor;
    if (isGoldenTheme) {
      defaultColor = Colors.amber;
    } else if (isDarkTheme) {
      defaultColor = Colors.white;
    } else {
      defaultColor = Colors.black;
    }

    return GoogleFonts.ubuntu(
      textStyle: TextStyle(
        fontSize: fontSize,
        color: color ?? defaultColor,
        fontWeight: isBold ? FontWeight.w800 : FontWeight.normal,
      ),
    );
  }
}
