import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DayCallendar extends StatefulWidget {
  const DayCallendar({
    required this.width,
    required this.height,
    required this.symbol,
    required this.background,
    required this.fill,
    required this.disabled,
    required this.max,
    required this.value,
    required this.oldHeight,
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

  final double oldHeight;

  @override
  State<DayCallendar> createState() => DayCallendarState();
}

class DayCallendarState extends State<DayCallendar> {
  // Size Variables
  final double heightOffset = 32;
  final double symbolSize = 18;
  final double valueSize = 20;

  // Animation Variables
  late bool finishedAnimation = false;
  final Duration animationDuration = const Duration(milliseconds: 250);
  final Duration delayDuration = const Duration(milliseconds: 10);
  final Curve curve = Curves.easeInOut;

  Future<void> animate() async {
    Future.delayed(delayDuration, () {
      setState(() {
        finishedAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value >= 0) {
      final double newHeight =
          (widget.height * 0.6) * (widget.value / widget.max);
      if (finishedAnimation == false) {
        animate();
      }

      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: widget.width,
              height: widget.height * 0.2,
              alignment: Alignment.center,
              child: Text(
                widget.symbol,
                style: GoogleFonts.poppins(
                  color: widget.disabled,
                  fontSize: symbolSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: widget.width,
              height: widget.height * 0.8,
              decoration: BoxDecoration(
                color: widget.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: curve,
                    width: widget.width,
                    height: finishedAnimation ? newHeight : widget.oldHeight,
                    decoration: BoxDecoration(
                      color: widget.fill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  AnimatedContainer(
                    // color: Colors.red.withOpacity(0.4),
                    duration: animationDuration,
                    curve: curve,
                    width: widget.width,
                    height: finishedAnimation
                        ? newHeight + heightOffset
                        : widget.oldHeight + heightOffset,
                    alignment: const Alignment(0, -0.94),
                    child: Text(
                      widget.value.toString(),
                      style: GoogleFonts.poppins(
                        color: widget.fill,
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
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: widget.width,
              height: widget.height * 0.2,
              alignment: Alignment.center,
              child: Text(
                widget.symbol,
                style: GoogleFonts.poppins(
                  color: widget.disabled,
                  fontSize: symbolSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: widget.width,
              height: widget.height * 0.8,
              decoration: BoxDecoration(
                color: widget.disabled.withOpacity(0.16),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        ),
      );
    }
  }
}
