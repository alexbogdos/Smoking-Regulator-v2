import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/custom_colors.dart';

class Toggle extends StatelessWidget {
  const Toggle({
    Key? key,
    this.active = true,
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

  final bool active;

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
          light: active
              ? CColors.white
              : Color.lerp(CColors.white, CColors.lightGrey, 0.60) as Color,
          dark: active
              ? CColors.darkGrey
              : Color.lerp(CColors.darkGrey, CColors.dark, 0.60) as Color,
          amoled: active
              ? CColors.dark
              : Color.lerp(CColors.dark, CColors.black, 0.45) as Color,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          Container(
            width: box1Width,
            padding: EdgeInsets.only(right: box1Width * 0.125),
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: active ? CColors.dark : CColors.darkGrey,
                  dark: active
                      ? CColors.white
                      : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.5)
                          as Color,
                  amoled: active
                      ? CColors.white
                      : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.6)
                          as Color,
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
              onTap: active ? action : () {},
              onLongPress: active ? secondaryAction : () {},
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: Container(
                width: box2Width,
                // color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: box2Width * 0.125),
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: getColor(
                      colorMode: colorMode,
                      isAmoled: isAmoled,
                      light: active ? CColors.dark : CColors.darkGrey,
                      dark: active
                          ? CColors.white
                          : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.5)
                              as Color,
                      amoled: active
                          ? CColors.white
                          : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.6)
                              as Color,
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
