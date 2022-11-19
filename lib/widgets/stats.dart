import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoking_regulator_v2/custom_colors.dart';
import 'package:smoking_regulator_v2/custom_functions.dart';
import 'package:smoking_regulator_v2/widgets/info_tab.dart';

class Stats extends StatefulWidget {
  const Stats({
    Key? key,
    required this.infoTabWidth,
    required this.infoTabHeight,
    required this.colorMode,
    required this.isAmoled,
  }) : super(key: key);

  final double infoTabWidth;
  final double infoTabHeight;
  final String colorMode;
  final bool isAmoled;

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> {
  late bool loaded = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    retrieveSum().then(
      (value) => retrievePopulation().then(
        (value) => setState(
          () {
            //! loaded = true;
            loaded = true;
          },
        ),
      ),
    );
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
    }
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
          if (DTools().dateIsBigger(date1: DateTime.now(), date2: lastDate!)) {
            await prefs.setInt("Population", value + 1);
            await prefs.setString(
                "LastDate", DTools().toStr(date: DateTime.now()));
            population = value + 1;
          }
        } else {
          await prefs.setString(
              "LastDate", DTools().toStr(date: DateTime.now()));
        }

        setState(() {});
        return;
      }
    }
  }

  void setSum({required int sumValue}) {
    // log(title: "Sum", value: sumValue);
    setState(() {
      sum = sumValue;
    });
  }

  void setPopulation({required int populationValue}) {
    // log(title: "Population", value: populationValue);
    setState(() {
      population = populationValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final divValue = sum / population;

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
                value: divValue.round(),
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
                title: "Week\nAverage",
                value: divValue.round() * 7,
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
                title: "Month\nAverage",
                value: divValue.round() * 30,
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
