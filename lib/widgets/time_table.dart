import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/custom_functions.dart';
import 'package:smoking_regulator_v2/widgets/table_divider.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({
    required this.width,
    required this.height,
    required this.countController,
    required this.background,
    required this.text,
    required this.divider,
    super.key,
  });

  final double width;
  final double height;

  final Color background;
  final Color text;
  final Color divider;

  final CountController countController;

  final double dividerWidthMultiplier = 0.9;
  final double dividerHeightMultiplier = 0.015;

  final double listWidthMultiplier = 0.6;
  final double listHeightMultiplier = 0.68;

  final double radius = 45;

  final double space = 0.065;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> list = countController.timetable;

    return Container(
      width: width,
      height: list.isNotEmpty ? height : height * 0.6,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            "History",
            style: GoogleFonts.poppins(
              color: text,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          TableDivider(
            width: width * dividerWidthMultiplier,
            height: height * dividerHeightMultiplier,
            color: divider,
          ),
          SizedBox(height: height * space),
          HistoryList(
            width: width * listWidthMultiplier,
            height: list.isNotEmpty
                ? height * listHeightMultiplier
                : height * 0.4 * listHeightMultiplier,
            text: text,
            items: list,
          )
        ],
      ),
    );
  }
}

class HistoryList extends StatelessWidget {
  HistoryList({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.items,
  });

  final double width;
  final double height;

  final List items;

  final Color text;

  // "${items.length - index}th ${items[index]}"

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    log(title: "Time Table (History List)", value: items);

    return SizedBox(
      width: width,
      height: height,
      // color: Colors.white,
      // alignment: Alignment.topCenter,
      child: items.isNotEmpty
          ? ListView.builder(
              itemCount: items.length,
              controller: scrollController,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return TimeCard(
                  key: ValueKey(index),
                  index: index,
                  width: width,
                  items: items,
                  text: text,
                );
              },
            )
          : Align(
              alignment: const Alignment(0, -0.7),
              child: Text(
                "No cigaretes\nsmoked today",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: text,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
    );
  }
}

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

  final double indexWidthMultiplier = 0.43;
  final double timeWidthMultiplier = 0.50;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.purpleAccent,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * indexWidthMultiplier,
            // color: Colors.white54,
            alignment: Alignment.centerRight,
            child: Text(
              "${items.length - index}th",
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
              "${items[items.length - 1 - index]}",
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
