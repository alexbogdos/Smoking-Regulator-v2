import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';

class CColors {
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color darkGrey = Color.fromARGB(255, 104, 104, 104);
  static const Color dark = Color.fromARGB(255, 20, 24, 27);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
}

// Color Mode Cycle Bounds
const int min = 0700;
int sunSetTime = 1730;

void setNewSunSetTime(int newTime) {
  sunSetTime = newTime;
}

// Get corresponding color according to the color mode
Color getColor({
  required String colorMode,
  required bool isAmoled,
  required Color light,
  required Color dark,
  required Color amoled,
  double? opacity,
}) {
  if (colorMode == "Dark") {
    if (isAmoled == true) {
      return amoled.withOpacity(opacity ?? 1);
    } else {
      return dark.withOpacity(opacity ?? 1);
    }
  } else if (colorMode == "Cycle") {
    final int timenow = int.parse(timetoString(DateTime.now(), clear: true));
    log(title: "Custom Colors (getColor)", value: "$timenow  $sunSetTime");
    if (min <= timenow && timenow < sunSetTime) {
      return light.withOpacity(opacity ?? 1);
    } else {
      if (isAmoled == true) {
        return amoled.withOpacity(opacity ?? 1);
      } else {
        return dark.withOpacity(opacity ?? 1);
      }
    }
  } else {
    return light.withOpacity(opacity ?? 1);
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
