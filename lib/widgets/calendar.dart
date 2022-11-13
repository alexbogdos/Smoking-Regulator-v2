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
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getDataAtStart();
  }

  void getDataAtStart() {
    getDataPerDay(0).then((value) => setLoaded());
  }

  void setLoaded() {
    setState(() {
      //! loaded = true;
      loaded = true;
    });
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
        if (currentDayIndex > 0) {
          currentDayIndex -= 1;
          wholeDate =
              DateTime.now().subtract(const Duration(days: 1)).toString();
          date = wholeDate.substring(0, 10);
          isCase0 = false;
        } else {
          getDataPerDay(1);
          weekOffset = 1;
          return;
        }
      } else if (1200 <= changeDay &&
          (1200 <= intHour && changeDay <= intHour)) {
        if (currentDayIndex < 6) {
          currentDayIndex += 1;
          wholeDate = DateTime.now().add(const Duration(days: 1)).toString();
          date = wholeDate.substring(0, 10);
          isCase2 = true;
          isCase0 = false;
        }
      }

      final newCount =
          await retrieveCount(key: date, isCase2: isCase2, isCase0: isCase0);
      if (weekOffset == 0) {
        setState(() {
          values[currentDayIndex] = newCount;
        });
      }
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
    final String date = wholeDate.substring(0, 10);

    final int currentDayIndex = DateTime.now().weekday - 1;
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
      // print(DateTime.now().weekday);
      // print(daysBefore);
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

  String getText() {
    if (weekOffset == 0) {
      return "Showing stats from current week";
    } else if (weekOffset == 1) {
      return "Showing stats from $weekOffset week in the past";
    } else {
      return "Showing stats from $weekOffset weeks in the past";
    }
  }

  Widget instansiateDC({
    required String symbol,
    required int value,
    required int max,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DayCallendar(
        width: widget.width * 0.076,
        height: widget.height * dayCalendarHeightFactor,
        symbol: symbol,
        background: widget.background,
        fill: widget.fill,
        disabled: widget.disabled,
        max: max,
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int max = getMax(list: values);

    return loaded
        ? Column(
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
                          Icons.arrow_back_ios_new_rounded,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        instansiateDC(
                          symbol: "M",
                          value: values[0],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "T",
                          value: values[1],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "W",
                          value: values[2],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "T",
                          value: values[3],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "F",
                          value: values[4],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "S",
                          value: values[5],
                          max: max,
                        ),
                        instansiateDC(
                          symbol: "S",
                          value: values[6],
                          max: max,
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
                          Icons.arrow_forward_ios_rounded,
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
                  getText(),
                  style: GoogleFonts.poppins(
                    color: widget.disabled.withOpacity(0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          )
        : Container(
            height: widget.height + widget.height * bottomScaleFactor,
            decoration: BoxDecoration(
              color: widget.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: widget.fill,
              ),
            ),
          );
  }
}
