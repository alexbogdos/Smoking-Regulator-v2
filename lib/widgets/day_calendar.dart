import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DayCallendar extends StatelessWidget {
  const DayCallendar({
    required this.width,
    required this.height,
    required this.symbol,
    required this.background,
    required this.fill,
    required this.disabled,
    required this.max,
    required this.value,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final String symbol;
  final Color background;
  final Color fill;
  final Color disabled;

  final int max;
  final int value;

  final double heightOffset = 32;

  final double symbolSize = 18;
  final double valueSize = 20;

  @override
  Widget build(BuildContext context) {
    if (value >= 0) {
      return SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.2,
              alignment: Alignment.center,
              child: Text(
                symbol,
                style: GoogleFonts.poppins(
                  color: disabled,
                  fontSize: symbolSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: width,
                    height: (height * 0.6) * (value / max),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    // color: Colors.red.withOpacity(0.4),
                    width: width,
                    height: (height * 0.6) * (value / max) + heightOffset,
                    alignment: const Alignment(0, -0.94),
                    child: Text(
                      value.toString(),
                      style: GoogleFonts.poppins(
                        color: fill,
                        fontSize: valueSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        // color: Colors.black.withOpacity(0.4),
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: width,
              height: height * 0.2,
              alignment: Alignment.center,
              child: Text(
                symbol,
                style: GoogleFonts.poppins(
                  color: disabled,
                  fontSize: symbolSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: disabled.withOpacity(0.16),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        ),
      );
    }
  }
}
