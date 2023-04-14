import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';

class InputToggle extends StatefulWidget {
  const InputToggle({
    Key? key,
    this.active = true,
    required this.width,
    required this.toggleHeight,
    required this.title,
    required this.value,
    required this.action,
    this.secondaryAction,
  }) : super(key: key);

  final double width;
  final double toggleHeight;

  final bool active;

  final String title;
  final String value;
  final Function(String value) action;
  final Function(String value)? secondaryAction;

  @override
  State<InputToggle> createState() => _InputToggleState();
}

class _InputToggleState extends State<InputToggle> {
  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  final TextEditingController controller = TextEditingController();
  late bool showCursor = true;

  @override
  Widget build(BuildContext context) {
    final double box1Width = widget.width * 0.582;
    final double lineWidth = widget.width * 0.006;
    final double box2Width = widget.width * 0.412;

    const double radius = 30;
    const double fontSize = 20;

    final Color textColor = getColor(
      light: widget.active ? CColors.dark : CColors.darkGrey,
      dark: widget.active
          ? CColors.white
          : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.5) as Color,
      amoled: widget.active
          ? CColors.white
          : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.6) as Color,
    );

    return Container(
      width: widget.width,
      height: widget.toggleHeight,
      decoration: BoxDecoration(
        color: getColor(
          light: widget.active
              ? CColors.white
              : Color.lerp(CColors.white, CColors.lightGrey, 0.60) as Color,
          dark: widget.active
              ? CColors.darkGrey
              : Color.lerp(CColors.darkGrey, CColors.dark, 0.60) as Color,
          amoled: widget.active
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
              widget.title,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: getColor(
                  light: widget.active ? CColors.dark : CColors.darkGrey,
                  dark: widget.active
                      ? CColors.white
                      : Color.lerp(CColors.lightGrey, CColors.darkGrey, 0.5)
                          as Color,
                  amoled: widget.active
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
              light: CColors.lightGrey,
              dark: CColors.dark,
              amoled: CColors.black,
            ),
            width: lineWidth,
          ),
          Container(
            width: box2Width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: box2Width * 0.125,
              right: box2Width * 0.125 * 2,
            ),
            child: TextField(
              textAlign: TextAlign.left,
              enabled: widget.active,
              showCursor: showCursor,
              controller: controller,
              cursorColor: textColor,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.value.toString(),
                hintStyle: GoogleFonts.poppins(
                  color: textColor.withOpacity(0.6),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              onSubmitted: (value) {
                setState(() {
                  widget.action(value);
                  if (controller.text == "") {
                    controller.text = widget.value;
                  }
                });
              },
              onTap: () {
                if (controller.text != "") {
                  setState(() {
                    showCursor = true;
                    controller.clear();
                  });
                }
              },
              onTapOutside: (event) {
                setState(() {
                  showCursor = false;
                  controller.text = widget.value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
