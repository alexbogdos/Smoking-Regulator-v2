import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/custom_colors.dart';
import 'package:smoking_regulator_v2/widgets/button.dart';
import 'package:smoking_regulator_v2/widgets/calendar.dart';
import 'package:smoking_regulator_v2/widgets/counter.dart';
import 'package:smoking_regulator_v2/widgets/stats.dart';
import 'package:smoking_regulator_v2/widgets/title.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.colorMode,
    required this.isAmoled,
    required this.factoredTime,
    required this.firstDate,
  }) : super(key: key);
  final String colorMode;
  final bool isAmoled;
  final String factoredTime;
  final String firstDate;

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
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.01),
              Stats(
                key: statsState,
                infoTabWidth: infoTabWidth,
                infoTabHeight: infoTabHeight,
                colorMode: colorMode,
                isAmoled: isAmoled,
              ),
              SizedBox(height: height * 0.05),
              Counter(
                key: counterkey,
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
                setSum: (int sum) {
                  statsState.currentState!.setSum(sumValue: sum);
                },
                setPopulation: (int population) {
                  statsState.currentState!
                      .setPopulation(populationValue: population);
                },
                factoredTime: widget.factoredTime,
              ),
              SizedBox(height: height * 0.03),
              Calendar(
                key: calendarkey,
                width: calendarWidth,
                height: calendarHeight,
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
                factoredTime: widget.factoredTime,
                firstDate: widget.firstDate,
              ),
              SizedBox(height: height * 0.06),
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
                  counterkey.currentState!.increase();
                },
                decrease: () {
                  counterkey.currentState!.decrease();
                },
                refreshCalendar: ({bool forceBuild = false}) {
                  calendarkey.currentState!.refresh(forceBuild: forceBuild);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
