import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

class Counter extends StatefulWidget {
  const Counter({
    required this.width,
    required this.height,
    required this.textColor,
    required this.subTextColor,
    required this.factoredTime,
    required this.countController,
    required this.dataController,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final Color textColor;
  final Color subTextColor;

  final String factoredTime;

  final CountController countController;
  final DataController dataController;

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  void refresh() {
    setState(() {
      // log(title: "Counter Widget (refresh)", value: "Refreshed");
    });
  }

  Color getTextColor(int count, int limit, List<Color> colors) {
    if (count == 0) {
      return colors[1];
    }

    if (count < limit * 0.6) {
      return colors[1];
    } else if (count < limit * 0.9) {
      return colors[2];
    } else {
      return colors[3];
    }
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.countController.count;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              color: getTextColor(
                count,
                widget.countController.limit,
                [
                  widget.textColor,
                  const Color(0xFF54ba89),
                  const Color(0xFFFFAB40),
                  const Color(0xFFFF5252)
                ],
              ),
              decoration: count > widget.countController.limit
                  ? TextDecoration.underline
                  : null,
              fontSize: 56,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Cigaretes Smoked Today",
            style: GoogleFonts.poppins(
              color: widget.subTextColor.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
