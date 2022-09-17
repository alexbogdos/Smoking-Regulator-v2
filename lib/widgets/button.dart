import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  const Button({
    required this.width,
    required this.height,
    required this.background,
    required this.textColor,
    required this.fill,
    required this.increase,
    required this.decrease,
    required this.refreshCalendar,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final Color background;
  final Color textColor;
  final Color fill;

  final Function() increase;
  final Function() decrease;
  final Function() refreshCalendar;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: width,
      height: height,
      child: TextButton(
        onPressed: () {
          increase();
          refreshCalendar();
        },
        onLongPress: () {
          decrease();
          refreshCalendar();
        },
        style: TextButton.styleFrom(
          backgroundColor: background,
          primary: fill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
        ),
        child: Text(
          "Increase",
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
