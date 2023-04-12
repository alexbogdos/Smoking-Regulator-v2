import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/widgets/more_page/history_view/history_list.dart';
import 'package:smoking_regulator_v2/widgets/more_page/history_view/table_divider.dart';

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
