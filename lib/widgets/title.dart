import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(
      {required this.width,
      required this.height,
      required this.textColor,
      Key? key})
      : super(key: key);

  final double width;
  final double height;
  final Color textColor;

  final String text1 = "Keep Healthy";
  final String text2 = "Regulate Smoking";
  final double size = 34;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: textColor.withOpacity(0.4),
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: size,
              fontWeight: FontWeight.w400,
              wordSpacing: 0,
            ),
          ),
          Text(
            text2,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: size,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
