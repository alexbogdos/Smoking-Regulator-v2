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
    required this.firstDate,
    required this.dataController,
    required this.calendarController,
    required this.countController,
  }) : super(key: key);

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorProfiles.background(),
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
                textColor: ColorProfiles.text(),
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
                textColor: ColorProfiles.text(),
                boxColor: ColorProfiles.box(),
              ),
              SizedBox(height: height * 0.030),
              Counter(
                key: counterkey,
                countController: widget.countController,
                dataController: widget.dataController,
                width: counterWidth,
                height: counterHeight,
                textColor: ColorProfiles.text(),
                subTextColor: ColorProfiles.subText(),
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
                background: ColorProfiles.box(),
                fill: ColorProfiles.text(),
                disabled: ColorProfiles.subText(),
                symbol: ColorProfiles.symbol(),
                subText: ColorProfiles.subText(),
              ),
              SizedBox(height: height * 0.04),
              Button(
                width: buttonWidth,
                height: buttonHeight,
                background: ColorProfiles.box(),
                textColor: ColorProfiles.text(),
                fill: ColorProfiles.boxAlt(),
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
