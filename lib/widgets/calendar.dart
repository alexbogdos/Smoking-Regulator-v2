import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoking_regulator_v2/widgets/day_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.width,
    required this.height,
    required this.background,
    required this.fill,
    required this.disabled,
    required this.factoredTime,
  }) : super(key: key);

  final double width;
  final double height;

  final Color background;
  final Color fill;
  final Color disabled;

  final String factoredTime;

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    getDataPerDay(0);
  }

  late int pastWeekOffset = 0;
  late int weekOffset = 0;
  void refresh({bool forceBuild = false}) async {
    if (pastWeekOffset == weekOffset && forceBuild == false) {
      return;
    }

    if (forceBuild) {
      late bool isCase2 = false;
      late bool isCase0 = true;

      late String wholeDate = DateTime.now().toString();
      late String date = wholeDate.substring(0, 10);
      late int currentDayIndex = DateTime.now().weekday - 1;

      late String hour = wholeDate.substring(11, 16);
      hour = hour.replaceAll(":", "");
      final intHour = int.parse(hour);
      int changeDay = int.parse(widget.factoredTime);

      if ((0000 <= changeDay && changeDay < 1200) &&
          (0000 <= intHour && intHour < changeDay)) {
        values[currentDayIndex] = -1;

        currentDayIndex -= 1;
        wholeDate = DateTime.now().subtract(const Duration(days: 1)).toString();
        date = wholeDate.substring(0, 10);
        isCase0 = false;
      } else if (1200 <= changeDay &&
          (1200 <= intHour && changeDay <= intHour)) {
        currentDayIndex += 1;
        wholeDate = DateTime.now().add(const Duration(days: 1)).toString();
        date = wholeDate.substring(0, 10);
        isCase2 = true;
        isCase0 = false;
      }

      final newCount =
          await retrieveCount(key: date, isCase2: isCase2, isCase0: isCase0);
      setState(() {
        values[currentDayIndex] = newCount;
      });
      return;
    }

    await getDataPerDay(weekOffset);
    pastWeekOffset = weekOffset;
  }

  final double centerScaleFactor = 0.74;
  final double sidesScaleFactor = 0.13;
  final double bottomScaleFactor = 0.16;

  final double dayCalendarWidthFactor = 0.08;
  final double dayCalendarHeightFactor = 1;

  final List<int> values = [-1, -1, -1, -1, -1, -1, -1];

  //
  //
  //

  Future<void> getDataPerDay(int offset) async {
    final String wholeDate = DateTime.now().toString();
    late String date = wholeDate.substring(0, 10);

    final int currentDayIndex = DateTime.now().weekday - 1; // + startingOffset;
    if (offset < 0) {
      offset = 0;
    }

    if (offset == 0) {
      late int daysBefore = 0;
      for (int index = 6; index >= 0; index--) {
        if (index > currentDayIndex) {
          values[index] = -1;
        } else if (index == currentDayIndex) {
          values[index] = await retrieveCount(key: date);
          if (values[index] < 0) {
            values[index] = 0;
          }
        } else {
          daysBefore += 1;
          String kDate =
              DateTime.now().subtract(Duration(days: daysBefore)).toString();
          kDate = kDate.substring(0, 10);
          values[index] = await retrieveCount(key: kDate);
        }
      }
      // setState(() {
      refresh(forceBuild: true);
      // });
    } else {
      late int daysBefore = (DateTime.now().weekday - 1) + (offset - 1) * 7;
      for (int index = 6; index >= 0; index--) {
        daysBefore += 1;
        String kDate =
            DateTime.now().subtract(Duration(days: daysBefore)).toString();
        kDate = kDate.substring(0, 10);
        values[index] = await retrieveCount(key: kDate);
      }
    }

    setState(() {});
  }

  Future<int> retrieveCount(
      {required String key, bool isCase2 = false, bool isCase0 = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      final int? value = prefs.getInt(key);
      if (value != null) {
        return value;
      }
    }

    if (isCase2 || isCase0) {
      return 0;
    }
    return -1;
  }

  int getMax({required List<int> list}) {
    int kMax = -1;
    for (int val in values) {
      if (val > kMax) {
        kMax = val;
      }
    }

    if (kMax > 0) {
      return kMax;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int max = getMax(list: values);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              // color: Colors.red.withOpacity(0.4),
              width: widget.width * sidesScaleFactor,
              height: widget.height,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    weekOffset += 1;
                    refresh();
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: widget.disabled.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            SizedBox(
              // color: Colors.blueAccent.withOpacity(0.4),
              width: widget.width * centerScaleFactor,
              height: widget.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "M",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[0],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "T",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[1],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "W",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[2],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "T",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[3],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "F",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[4],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "S",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[5],
                  ),
                  DayCallendar(
                    width: widget.width * dayCalendarWidthFactor,
                    height: widget.height * dayCalendarHeightFactor,
                    symbol: "S",
                    background: widget.background,
                    fill: widget.fill,
                    disabled: widget.disabled,
                    max: max,
                    value: values[6],
                  ),
                ],
              ),
            ),
            SizedBox(
              // color: Colors.red.withOpacity(0.4),
              width: widget.width * sidesScaleFactor,
              height: widget.height,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    if (weekOffset > 0) {
                      weekOffset -= 1;
                      refresh();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    color: weekOffset == 0
                        ? widget.disabled.withOpacity(0.25)
                        : widget.disabled.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          // color: Colors.yellowAccent.withOpacity(0.4),
          width: widget.width,
          height: widget.height * bottomScaleFactor,
          alignment: Alignment.bottomCenter,
          child: Text(
            weekOffset == 0
                ? "Showing stats from current week"
                : weekOffset == 1
                    ? "Showing stats from $weekOffset week in the past"
                    : "Showing stats from $weekOffset weeks in the past",
            style: GoogleFonts.poppins(
              color: widget.disabled.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
