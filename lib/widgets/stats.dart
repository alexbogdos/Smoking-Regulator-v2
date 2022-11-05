import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoking_regulator_v2/custom_colors.dart';
import 'package:smoking_regulator_v2/widgets/info_tab.dart';

class Stats extends StatefulWidget {
  const Stats({
    Key? key,
    required this.infoTabWidth,
    required this.infoTabHeight,
    required this.darkMode,
  }) : super(key: key);

  final double infoTabWidth;
  final double infoTabHeight;
  final bool darkMode;

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> {
  late bool done = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    retrieveSum()
        .then((value) => retrievePopulation().then((value) => setState(() {
              done = true;
            })));
  }

  late int sum = 0;
  late int population = 1;

  Future<void> retrieveSum() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("Sum")) {
      final int? value = prefs.getInt("Sum");

      if (value != null) {
        sum = value;
        return;
      }
    } else {}
  }

  Future<void> retrievePopulation() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    if (prefs.containsKey("Population")) {
      final int? value = prefs.getInt("Population");
      if (value != null) {
        population = value;

        if (prefs.containsKey("LastDate")) {
          final String? lastDate = prefs.getString("LastDate");
          if (lastDate != DateTime.now().toString().substring(0, 10)) {
            await prefs.setInt("Population", value + 1);
            await prefs.setString(
                "LastDate", DateTime.now().toString().substring(0, 10));
            population = value + 1;
          }
          // else {
          //   // await prefs.setInt("Population", value - 1);
          //   setPopulation((value));
          // }
        } else {
          await prefs.setString(
              "LastDate", DateTime.now().toString().substring(0, 10));
        }

        setState(() {});
        return;
      }
    }
  }

  void setSum({required int sumValue}) {
    setState(() {
      sum = sumValue;
    });
  }

  void setPopulation({required int populationValue}) {
    setState(() {
      population = populationValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor:
                    widget.darkMode == false ? CColors.white : CColors.black,
                textColor:
                    widget.darkMode == false ? CColors.black : CColors.white,
                title: "Day\nAverage",
                value: (sum / population).round(),
              ),
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor:
                    widget.darkMode == false ? CColors.white : CColors.black,
                textColor:
                    widget.darkMode == false ? CColors.black : CColors.white,
                title: "Week\nAverage",
                value: (sum / population).round() * 7,
              ),
              InfoTab(
                width: widget.infoTabWidth,
                height: widget.infoTabHeight,
                boxColor:
                    widget.darkMode == false ? CColors.white : CColors.black,
                textColor:
                    widget.darkMode == false ? CColors.black : CColors.white,
                title: "Month\nAverage",
                value: (sum / population).round() * 30,
              ),
            ],
          )
        : Container(
            width: widget.infoTabWidth * 3,
            height: widget.infoTabHeight,
            decoration: BoxDecoration(
              color: widget.darkMode == false ? CColors.white : CColors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: widget.darkMode == false ? CColors.black : CColors.white,
              ),
            ),
          );
  }
}
