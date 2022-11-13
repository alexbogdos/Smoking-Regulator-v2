import 'package:flutter/material.dart';

class CColors {
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color darkGrey = Color.fromARGB(255, 104, 104, 104);
  static const Color black = Color.fromARGB(255, 20, 24, 27);
}

// Get corresponding color according to the color mode
Color getColor(bool darkMode, Color light, Color dark) {
  if (darkMode == false) {
    return light;
  }
  return dark;
}
