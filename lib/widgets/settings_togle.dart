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

    return Container(
      width: width,
      height: toggleHeight,
      decoration: BoxDecoration(
        color: darkMode == false ? CColors.white : CColors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: box1Width,
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: darkMode == false ? CColors.black : CColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            color: darkMode == false ? CColors.black : CColors.white,
            width: lineWidth,
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor:
                  darkMode == false ? CColors.darkGrey : CColors.lightGrey,
              onTap: action,
              onLongPress: secondaryAction,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Container(
                width: box2Width,
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: darkMode == false ? CColors.black : CColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
