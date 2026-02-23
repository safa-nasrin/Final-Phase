import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeWidgets {
  static Widget headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.blue[800],
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget subtitleText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }
}
