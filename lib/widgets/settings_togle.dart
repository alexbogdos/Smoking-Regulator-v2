import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/custom_colors.dart';

class Toggle extends StatelessWidget {
  const Toggle({
    Key? key,
    required this.width,
    required this.toggleHeight,
    required this.colorMode,
    required this.isAmoled,
    required this.title,
    required this.value,
    required this.action,
    this.secondaryAction,
  }) : super(key: key);

  final double width;
  final double toggleHeight;
  final String colorMode;
  final bool isAmoled;

  final String title;
  final String value;
  final Function() action;
  final Function()? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final double box1Width = width * 0.582;
    final double lineWidth = width * 0.006;
    final double box2Width = width * 0.412;

    const double radius = 30;
    const double fontSize = 20;

    return Container(
      width: width,
      height: toggleHeight,
      decoration: BoxDecoration(
        color: getColor(
          colorMode: colorMode,
          isAmoled: isAmoled,
          light: CColors.white,
          dark: CColors.darkGrey,
          amoled: CColors.dark,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          Container(
            width: box1Width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: box1Width * 0.2),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.white,
                ),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            color: getColor(
              colorMode: colorMode,
              isAmoled: isAmoled,
              light: CColors.lightGrey,
              dark: CColors.dark,
              amoled: CColors.black,
            ),
            width: lineWidth,
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor: getColor(
                colorMode: colorMode,
                isAmoled: isAmoled,
                light: CColors.dark,
                dark: CColors.lightGrey,
                amoled: CColors.white,
              ),
              onTap: action,
              onLongPress: secondaryAction,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: Container(
                width: box2Width,
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: getColor(
                      colorMode: colorMode,
                      isAmoled: isAmoled,
                      light: CColors.dark,
                      dark: CColors.white,
                      amoled: CColors.white,
                    ),
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
