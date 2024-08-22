import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle normalText(
      {double fontSize = 14, Color color = Colors.black, bool isBold = false}) {

    return GoogleFonts.ubuntu(
        textStyle: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.normal));
  }
}
