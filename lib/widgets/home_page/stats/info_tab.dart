import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoTab extends StatelessWidget {
  const InfoTab(
      {required this.width,
      required this.height,
      required this.boxColor,
      required this.textColor,
      required this.title,
      required this.value,
      Key? key})
      : super(key: key);

  final double width;
  final double height;
  final Color boxColor;
  final Color textColor;

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: boxColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              value.toString(),
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
