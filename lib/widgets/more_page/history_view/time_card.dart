import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({
    super.key,
    required this.index,
    required this.width,
    required this.items,
    required this.text,
  });

  final int index;
  final double width;
  final List items;
  final Color text;

  final double fontSize = 18;

  final double indexWidthMultiplier = 0.41;
  final double timeWidthMultiplier = 0.52;
  // final double timeWidthMultiplier = 1;

  @override
  Widget build(BuildContext context) {
    late String item = items[items.length - 1 - index].toString();

    // if (item[0] == "0") {
    //   item = "0${item.substring(1)}";
    // }

    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * indexWidthMultiplier,
            // color: Colors.white54,
            alignment: Alignment.centerRight,
            child: Text(
              "${items.length - index}.",
              style: GoogleFonts.poppins(
                color: text,
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
              ),
            ),
          ),
          Container(
            width: width * timeWidthMultiplier,
            // color: Colors.white54,
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                color: text,
                fontWeight: FontWeight.w500,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
