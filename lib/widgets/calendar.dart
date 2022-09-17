import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    required this.width,
    required this.height,
    required this.background,
    required this.fill,
    required this.disabled,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final Color background;
  final Color fill;
  final Color disabled;

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    getDataPerDay(0);
  }

  late int weekOffset = 0;
  void refresh() async {
    await getDataPerDay(weekOffset);
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
          String _date =
              DateTime.now().subtract(Duration(days: daysBefore)).toString();
          _date = _date.substring(0, 10);
          values[index] = await retrieveCount(key: _date);
        }
      }
    } else {
      late int daysBefore = (DateTime.now().weekday - 1) + (offset - 1) * 7;
      for (int index = 6; index >= 0; index--) {
        daysBefore += 1;
        String _date =
            DateTime.now().subtract(Duration(days: daysBefore)).toString();
        _date = _date.substring(0, 10);
        values[index] = await retrieveCount(key: _date);
      }
    }

    setState(() {});
  }

  Future<int> retrieveCount({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      final int? value = prefs.getInt(key);
      if (value != null) {
        return value;
      }
    }

    return -1;
  }

  //
  //
  //

  int getMax({required List<int> list}) {
    int _max = -1;
    for (int val in values) {
      if (val > _max) {
        _max = val;
      }
    }

    if (_max > 0) {
      return _max;
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
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: widget.width * sidesScaleFactor,
              height: widget.height,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    weekOffset += 1;
                    refresh();
                  },
                  style: TextButton.styleFrom(primary: Colors.red),
                  child: Text(
                    "<",
                    style: GoogleFonts.poppins(
                      color: widget.disabled.withOpacity(0.8),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Container(
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
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: widget.width * sidesScaleFactor,
              height: widget.height,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    if (weekOffset > 0) {
                      weekOffset -= 1;
                    }
                    refresh();
                  },
                  child: Text(
                    ">",
                    style: GoogleFonts.poppins(
                      color: widget.disabled.withOpacity(0.8),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
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
                ? "Sowing stats from current week"
                : weekOffset == 1
                    ? "Sowing stats from $weekOffset week in the past"
                    : "Sowing stats from $weekOffset weeks in the past",
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

class DayCallendar extends StatelessWidget {
  const DayCallendar({
    required this.width,
    required this.height,
    required this.symbol,
    required this.background,
    required this.fill,
    required this.disabled,
    required this.max,
    required this.value,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final String symbol;
  final Color background;
  final Color fill;
  final Color disabled;

  final int max;
  final int value;

  final double heightOffset = 34;

  @override
  Widget build(BuildContext context) {
    // print("${value!} $max ${value! / max}");
    if (value >= 0) {
      return Container(
        // color: Colors.black.withOpacity(0.4),
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: width,
              height: height * 0.2,
              alignment: Alignment.center,
              child: Text(
                symbol,
                style: GoogleFonts.poppins(
                  color: disabled,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: width,
                    height: (height * 0.6) * (value / max),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    // color: Colors.red.withOpacity(0.4),
                    width: width,
                    height: (height * 0.6) * (value / max) + heightOffset,
                    alignment: const Alignment(0, -0.94),
                    child: Text(
                      value.toString(),
                      style: GoogleFonts.poppins(
                        color: fill,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        // color: Colors.black.withOpacity(0.4),
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              // color: Colors.red.withOpacity(0.4),
              width: width,
              height: height * 0.2,
              alignment: Alignment.center,
              child: Text(
                symbol,
                style: GoogleFonts.poppins(
                  color: disabled,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: disabled.withOpacity(0.16),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        ),
      );
    }
  }
}
