import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/custom_colors.dart';

class Toggle extends StatelessWidget {
  const Toggle({
    Key? key,
    required this.width,
    required this.toggleHeight,
    required this.darkMode,
    required this.title,
    required this.value,
    required this.action,
    this.secondaryAction,
  }) : super(key: key);

  final double width;
  final double toggleHeight;
  final bool darkMode;

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
        color: getColor(darkMode, CColors.white, CColors.darkGrey),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          Container(
            width: box1Width,
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: getColor(darkMode, CColors.black, CColors.white),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            color: getColor(darkMode, CColors.lightGrey, CColors.black),
            width: lineWidth,
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor:
                  getColor(darkMode, CColors.darkGrey, CColors.lightGrey),
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
                    color: getColor(darkMode, CColors.black, CColors.white),
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
