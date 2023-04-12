import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/calendar_controller.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';
import 'package:smoking_regulator_v2/widgets/home_page/counter/button.dart';
import 'package:smoking_regulator_v2/widgets/home_page/calendar/calendar.dart';
import 'package:smoking_regulator_v2/widgets/home_page/counter/counter.dart';
import 'package:smoking_regulator_v2/widgets/home_page/stats/stats.dart';
import 'package:smoking_regulator_v2/widgets/shared/title.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.colorMode,
    required this.isAmoled,
    required this.firstDate,
    required this.dataController,
    required this.calendarController,
    required this.countController,
  }) : super(key: key);
  final String colorMode;
  final bool isAmoled;
  final String firstDate;
  final DataController dataController;
  final CalendarController calendarController;
  final CountController countController;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<CounterState> counterkey = GlobalKey();
  final GlobalKey<CalendarState> calendarkey = GlobalKey();
  final GlobalKey<StatsState> statsState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Size Assets
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double width = screenWidth * 0.84;
    final double height = screenHeight * 0.94;

    final double pageTitleHeight = height * 0.14;

    final double infoTabWidth = width * 0.3;
    final double infoTabHeight = height * 0.16;
    final double chipHeight = height * 0.04;
    final double seperatorHeight = height * 0.02;

    final double counterWidth = width;
    final double counterHeight = height * 0.16;

    final double calendarWidth = width;
    final double calendarHeight = height * 0.22;

    final double buttonWidth = width;
    final double buttonHeight = height * 0.1;

    // Color Mode Assets
    final String colorMode = widget.colorMode;
    final bool isAmoled = widget.isAmoled;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: getColor(
        colorMode: colorMode,
        isAmoled: isAmoled,
        light: CColors.lightGrey,
        dark: CColors.dark,
        amoled: CColors.black,
      ),
      body: Align(
        alignment: const Alignment(0, 0.3),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              PageTitle(
                width: width,
                height: pageTitleHeight,
                textColor: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
              ),
              SizedBox(height: height * 0.016),
              Stats(
                key: statsState,
                width: width,
                infoTabWidth: infoTabWidth,
                infoTabHeight: infoTabHeight,
                chipHeight: chipHeight,
                seperatorHeight: seperatorHeight,
                dataController: widget.dataController,
                calendarController: widget.calendarController,
                textColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                boxColor: getColor(
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
              ),
              SizedBox(height: height * 0.030),
              Counter(
                key: counterkey,
                countController: widget.countController,
                dataController: widget.dataController,
                width: counterWidth,
                height: counterHeight,
                textColor: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                subTextColor: getColor(
                    colorMode: colorMode,
                    isAmoled: isAmoled,
                    light: CColors.darkGrey,
                    dark: CColors.lightGrey,
                    amoled: CColors.darkGrey),
              ),
              SizedBox(height: height * 0.025),
              Calendar(
                key: calendarkey,
                width: calendarWidth,
                height: calendarHeight,
                calendarController: widget.calendarController,
                refreshStats: () {
                  statsState.currentState!.refresh();
                },
                background: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
                fill: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                disabled: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.darkGrey,
                  dark: CColors.lightGrey,
                  amoled: CColors.darkGrey,
                ),
                symbol: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.darkGrey,
                  dark: CColors.lightGrey,
                  amoled: CColors.lightGrey,
                ),
                subText: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.darkGrey,
                  dark: CColors.lightGrey,
                  amoled: CColors.darkGrey,
                ),
              ),
              SizedBox(height: height * 0.04),
              Button(
                width: buttonWidth,
                height: buttonHeight,
                background: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.white,
                  dark: CColors.darkGrey,
                  amoled: CColors.dark,
                ),
                textColor: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.dark,
                  dark: CColors.white,
                  amoled: CColors.lightGrey,
                ),
                fill: getColor(
                  colorMode: colorMode,
                  isAmoled: isAmoled,
                  light: CColors.darkGrey,
                  dark: CColors.lightGrey,
                  amoled: CColors.lightGrey,
                ),
                increase: () {
                  widget.countController.increase();
                  counterkey.currentState!.refresh();
                  statsState.currentState!.refresh();
                },
                decrease: () {
                  widget.countController.decrease();
                  counterkey.currentState!.refresh();
                  statsState.currentState!.refresh();
                },
                refreshCalendar: () {
                  calendarkey.currentState!.refresh();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
