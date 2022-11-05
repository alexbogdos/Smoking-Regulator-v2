import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  const Counter({
    required this.width,
    required this.height,
    required this.textColor,
    required this.subTextColor,
    required this.setSum,
    required this.setPopulation,
    required this.factoredTime,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;

  final Color textColor;
  final Color subTextColor;

  final Function(int value) setSum;
  final Function(int value) setPopulation;

  final String factoredTime;

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  late bool loaded = false;
  late String _prefsKey = "count";

  @override
  void initState() {
    super.initState();
    getPrefsKey();
  }

  void getPrefsKey() {
    final DateTime wholeDate = DateTime.now();
    final String date = wholeDate.toString().substring(0, 16);

    // #TO_DO
    // Let's say that i made an increase
    // at 00:31 while the 'Day Change' is at 5:30
    // it should show as a change at the day before
    // and not be counted in the next day
    //
    // It should be only SHOWN this way
    // and not actually be saved like that

    // EXPERIMENTAL FEATURE - START

    late String day = date.substring(0, 10);
    late String hour = date.substring(11, 16);
    hour = hour.replaceAll(":", "");

    final intHour = int.parse(hour);
    if (widget.factoredTime != "0000") {
      int changeDay = int.parse(widget.factoredTime);

      if ((0000 <= changeDay && changeDay < 1200) &&
          (0000 <= intHour && intHour < changeDay)) {
        day = day.replaceAll("-", "");
        late int intDay = int.parse(day);
        intDay = intDay - 1;

        final String kyear = intDay.toString().substring(0, 4);
        final String kmonth = intDay.toString().substring(4, 6);
        final String kday = intDay.toString().substring(6, 8);
        day = "$kyear-$kmonth-$kday";
      } else if (1200 <= changeDay &&
          (1200 <= intHour && changeDay <= intHour)) {
        day = day.replaceAll("-", "");
        late int intDay = int.parse(day);
        intDay = intDay + 1;

        final String kyear = intDay.toString().substring(0, 4);
        final String kmonth = intDay.toString().substring(4, 6);
        final String kday = intDay.toString().substring(6, 8);
        day = "$kyear-$kmonth-$kday";
      }
    }

    // EXPERIMENTAL FEAUTRE - END

    _prefsKey = day;
    retrieveCount();
  }

  Future<void> retrieveCount() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_prefsKey)) {
      final int? value = prefs.getInt(_prefsKey);
      if (value != null) {
        count = value;
      }
    }

    // await Future.delayed(const Duration(seconds: 3));

    setState(() {
      loaded = true;
    });
  }

  Future<void> saveCount({required int sumValue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, count);

    if (prefs.containsKey("Sum")) {
      final int? value = prefs.getInt("Sum");
      if (value != null) {
        await prefs.setInt("Sum", value + sumValue);
        await prefs.setInt("Sum", value + sumValue);
        widget.setSum((value + sumValue));
      }
    } else {
      await prefs.setInt("Sum", count);
    }

    if (prefs.containsKey("Population") && prefs.containsKey("LastDate")) {
      final int? value = prefs.getInt("Population");
      final String? lastDate = prefs.getString("LastDate");
      if (value != null) {
        if (lastDate != DateTime.now().toString().substring(0, 10)) {
          await prefs.setInt("Population", value + 1);
          await prefs.setString(
              "LastDate", DateTime.now().toString().substring(0, 10));
          widget.setPopulation((value + 1));
        } else {
          // await prefs.setInt("Population", value - 1);
          widget.setPopulation((value));
        }
      }
    } else {
      await prefs.setInt("Population", 1);
      await prefs.setString(
          "LastDate", DateTime.now().toString().substring(0, 10));
    }
  }

  late int count = 0;

  void increase() {
    setState(() {
      count += 1;
      saveCount(sumValue: 1);
    });
  }

  void decrease() {
    if (count <= 0) {
      return;
    }

    setState(() {
      count -= 1;
      saveCount(sumValue: -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.red.withOpacity(0.4),
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loaded == true
              ? Text(
                  count.toString(),
                  style: GoogleFonts.poppins(
                    color: widget.textColor,
                    fontSize: 56,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(widget.height * 0.172),
                  child: CircularProgressIndicator(
                    color: widget.textColor,
                  ),
                ),
          Text(
            "Cigaretes Smoked Today",
            style: GoogleFonts.poppins(
              color: widget.subTextColor.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
