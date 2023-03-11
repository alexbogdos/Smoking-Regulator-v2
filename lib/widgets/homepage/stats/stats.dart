import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/calendar_controller.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';
import 'package:smoking_regulator_v2/widgets/homepage/stats/info_tab.dart';

class Stats extends StatefulWidget {
  const Stats({
    Key? key,
    required this.infoTabWidth,
    required this.infoTabHeight,
    required this.colorMode,
    required this.isAmoled,
    required this.calendarController,
  }) : super(key: key);

  final double infoTabWidth;
  final double infoTabHeight;
  final String colorMode;
  final bool isAmoled;

  final CalendarController calendarController;

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> {
  late bool loaded = false;
  late int countSum = 0;
  late int population = 1;

  @override
  void initState() {
    super.initState();
    getStatsData();
  }

  void getStatsData() {
    setState(() {
      widget.calendarController.getData();
      loaded = true;
    });
  }

  late double divValue = 0;
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
                textColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                title: "Day\nAverage",
                value: (widget.calendarController.sum /
                        widget.calendarController.pop)
                    .round(),
              ),
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
                textColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                title: "Week\nMax",
                value: widget.calendarController.sum == 0
                    ? 0
                    : widget.calendarController.max,
              ),
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
                textColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                title: "Week\nSum",
                value: widget.calendarController.sum,
              ),
            ],
          )
        : Container(
            width: double.infinity,
            height: widget.infoTabHeight,
            decoration: BoxDecoration(
              color: getColor(
                colorMode: widget.colorMode,
                isAmoled: widget.isAmoled,
                light: CColors.white,
                dark: CColors.darkGrey,
                amoled: CColors.dark,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
              ),
            ),
          );
  }
}
