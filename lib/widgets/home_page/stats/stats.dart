import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/calendar_controller.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';
import 'package:smoking_regulator_v2/widgets/home_page/stats/info_tab.dart';
import 'package:smoking_regulator_v2/widgets/home_page/stats/selectable_chip.dart';

class Stats extends StatefulWidget {
  const Stats({
    Key? key,
    required this.width,
    required this.infoTabWidth,
    required this.infoTabHeight,
    required this.chipHeight,
    required this.seperatorHeight,
    required this.textColor,
    required this.boxColor,
    required this.dataController,
    required this.calendarController,
  }) : super(key: key);

  final double width;
  final double infoTabWidth;
  final double infoTabHeight;
  final double chipHeight;
  final double seperatorHeight;

  final Color textColor;
  final Color boxColor;

  final DataController dataController;
  final CalendarController calendarController;

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> {
  late bool loaded = false;
  late int countSum = 0;
  late int population = 1;
  late int selected = 0;

  @override
  void initState() {
    super.initState();
    getStatsData();
  }

  void getStatsData() {
    setState(() {
      selected = widget.dataController.getStatsView();
      widget.calendarController.getData();
      loaded = true;
    });
  }

  late double divValue = 0;
  void refresh() {
    setState(() {});
  }

  void select(index) {
    setState(() {
      selected = index;
      widget.dataController.setSetting(key: "Stats View", value: index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = widget.width * 0.5325;
    final double minWidth = widget.width * 0.4325;

    return loaded
        ? Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: widget.width,
                height: widget.chipHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableChip(
                      index: 0,
                      text: "Weekly",
                      maxWidth: maxWidth,
                      minWidth: minWidth,
                      height: widget.chipHeight,
                      selected: selected,
                      background: widget.boxColor,
                      foreground: widget.textColor,
                      select: select,
                    ),
                    // const SizedBox(width: 0.3),
                    SelectableChip(
                      index: 1,
                      text: "Monthly",
                      maxWidth: maxWidth,
                      minWidth: minWidth,
                      height: widget.chipHeight,
                      selected: selected,
                      background: widget.boxColor,
                      foreground: widget.textColor,
                      select: select,
                    )
                  ],
                ),
              ),
              SizedBox(height: widget.seperatorHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoTab(
                    width: widget.infoTabWidth,
                    height: widget.infoTabHeight,
                    boxColor: widget.boxColor,
                    textColor: widget.textColor,
                    title: "Day\nAverage",
                    value: selected == 0
                        ? (widget.calendarController.sum /
                                widget.calendarController.pop)
                            .round()
                        : (widget.calendarController.globalCountSum /
                                widget.calendarController.globalPopulation)
                            .round(),
                  ),
                  InfoTab(
                    width: widget.infoTabWidth,
                    height: widget.infoTabHeight,
                    boxColor: widget.boxColor,
                    textColor: widget.textColor,
                    title: selected == 0 ? "Week\nMax" : "Week\nAverage",
                    value: selected == 0
                        ? widget.calendarController.sum == 0
                            ? 0
                            : widget.calendarController.max
                        : (widget.calendarController.globalCountSum /
                                    widget.calendarController.globalPopulation)
                                .round() *
                            7,
                  ),
                  InfoTab(
                    width: widget.infoTabWidth,
                    height: widget.infoTabHeight,
                    boxColor: widget.boxColor,
                    textColor: widget.textColor,
                    title: selected == 0 ? "Week\nSum" : "Month\nAverage",
                    value: selected == 0
                        ? widget.calendarController.sum
                        : (widget.calendarController.globalCountSum /
                                    widget.calendarController.globalPopulation)
                                .round() *
                            7 *
                            4,
                  ),
                ],
              ),
            ],
          )
        : Container(
            width: double.infinity,
            height: widget.infoTabHeight,
            decoration: BoxDecoration(
              color: widget.boxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: widget.textColor,
              ),
            ),
          );
  }
}
