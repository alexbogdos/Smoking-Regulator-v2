import 'package:flutter/material.dart';

class CColors {
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color darkGrey = Color.fromARGB(255, 104, 104, 104);
  static const Color dark = Color.fromARGB(255, 20, 24, 27);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
}

// Color Mode Cycle Bounds
const int max = 17;
const int min = 7;

// Get corresponding color according to the color mode
Color getColor({
  required String colorMode,
  required bool isAmoled,
  required Color light,
  required Color dark,
  required Color amoled,
}) {
  if (colorMode == "Dark") {
    if (isAmoled == true) {
      return amoled;
    } else {
      return dark;
    }
  } else if (colorMode == "Cycle") {
    final int hour = DateTime.now().hour;
    if (min <= hour && hour < max) {
      return light;
    } else {
      if (isAmoled == true) {
        return amoled;
      } else {
        return dark;
      }
    }
  } else {
    return light;
  }
}

// Cycle through Dark Mode
String cycleColorMode({required String colorMode}) {
  if (colorMode == "Light") {
    return "Dark";
  } else if (colorMode == "Dark") {
    return "Cycle";
  } else {
    return "Light";
  }
}
