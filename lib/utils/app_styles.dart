import "package:flutter/material.dart";

class AppTheme {
  static const Color dark = Color(0xF1181818);
  static const Color med = Color(0x50FFFFFF);
  static const Color accent = Color(0xFF007cba);
  static const Color light = Color(0xFFFFFFFF);
  static const Color splash = Color(0xff00b2d6);
  static const Color plane = Color (0xFF01416e);
  static const Color green = Color(0xFFb1d887);


  static const Color disabledbackgroundColor = Colors.black12;
  static const Color disabledforegroundColor = Colors.white12;

  static const TextStyle inputStyle = TextStyle(color: light, fontSize: 20);
  static const TextStyle hintStyle = TextStyle(color: med);
  static const TextStyle counterStyle = TextStyle(color: med, fontSize:14);
  static const TextStyle splashStyle = TextStyle(
    color: AppTheme.green,
    fontSize: 30,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
  
  );
}