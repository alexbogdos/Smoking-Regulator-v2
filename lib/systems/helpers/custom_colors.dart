import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';

class ColorModes {
  static const String light = "Light";
  static const String dark = "Dark";
  static const String cycle = "Cycle";
}

class ColorProfiles {
  static Color text({double? opacity}) {
    return getColor(
      light: CColors.dark,
      dark: CColors.white,
      amoled: CColors.lightGrey,
      opacity: opacity,
    );
  }

  static Color subText({double? opacity}) {
    return getColor(
      light: CColors.darkGrey,
      dark: CColors.lightGrey,
      amoled: CColors.darkGrey,
      opacity: opacity,
    );
  }

  static Color symbol({double? opacity}) {
    return getColor(
      light: CColors.darkGrey,
      dark: CColors.lightGrey,
      amoled: CColors.lightGrey,
      opacity: opacity,
    );
  }

  static Color background({double? opacity}) {
    return getColor(
      light: CColors.lightGrey,
      dark: CColors.dark,
      amoled: CColors.black,
    );
  }

  static Color box({double? opacity}) {
    return getColor(
      light: CColors.white,
      dark: CColors.darkGrey,
      amoled: CColors.dark,
      opacity: opacity,
    );
  }

  static Color boxAlt({double? opacity}) {
    return getColor(
      light: CColors.dark,
      dark: CColors.lightGrey,
      amoled: CColors.lightGrey,
      opacity: opacity,
    );
  }
}

class CColors {
  //-- Settings -------------------------------
  static String _colorMode = ColorModes.cycle;
  static bool _isAmoled = false;

  //-- Colors -------------------------------
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color darkGrey = Color.fromARGB(255, 104, 104, 104);
  static const Color dark = Color.fromARGB(255, 20, 24, 27);
  static const Color black = Color.fromARGB(255, 0, 0, 0);

  //-- Getters -------------------------------
  static String colorMode() {
    return _colorMode;
  }

  static bool isAmoled() {
    return _isAmoled;
  }

  //-- Setters -------------------------------
  static void toggleAmoled() {
    _isAmoled = !_isAmoled;
  }

  // Cycle through Color Modes
  static void toggleColorMode(String currentColorMode) {
    if (currentColorMode == ColorModes.light) {
      setColorMode(ColorModes.dark);
    } else if (currentColorMode == ColorModes.dark) {
      setColorMode(ColorModes.cycle);
    } else {
      setColorMode(ColorModes.light);
    }
  }

  static void setColorMode(String colorMode) {
    _colorMode = colorMode;
  }

  static void setIsAmoled(bool isAmoled) {
    _isAmoled = isAmoled;
  }
}

// Color Mode Cycle Bounds
const int min = 0700;
int sunSetTime = 1730;

void setSunSetTime(int newTime) {
  sunSetTime = newTime;
}

// Get corresponding color according to the color mode
Color getColor({
  required Color light,
  required Color dark,
  required Color amoled,
  double? opacity,
}) {
  final int timenow = int.parse(timetoString(DateTime.now(), clear: true));

  bool isCycle = CColors.colorMode() == ColorModes.cycle;
  bool isAfterSunSet = !(min <= timenow && timenow < sunSetTime);
  bool isCycleAndAfter = isCycle && isAfterSunSet;

  bool isDark = CColors.colorMode() == ColorModes.dark;

  Color color = light;
  if (isCycleAndAfter || isDark) {
    color = CColors.isAmoled() ? amoled : dark;
  }

  return color.withOpacity(opacity ?? 1);
}
