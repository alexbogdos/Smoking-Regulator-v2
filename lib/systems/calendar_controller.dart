import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

class CalendarController {
  CalendarController({required this.dataController}) {
    globalCountSum = dataController.getCountSum();
    globalPopulation = dataController.getPopulation();

    weekgroup = dataController.getWeekGroup();
    weekoffset = weekgroup;

    getData();
  }

  final DataController dataController;

  late int globalCountSum = 0;
  late int globalPopulation = 1;

  late Map<String, dynamic> week = {};
  late int weekoffset = 0;
  late int weekgroup = 0;

  late int sum = 0;
  late int pop = 1;

  late String range = "";

  late int max = 1;

  late List<int> values = [-1, -1, -1, -1, -1, -1, -1];

  Future<void> getData() async {
    Map<String, dynamic>? tempweek =
        dataController.getfromData(weekgroupkey: weekoffset);

    log(
        title: "Calendar Controller (getData)",
        value:
            "WeekGroup: $weekgroup  WeekOffset: $weekoffset  Week: $tempweek");

    if (tempweek == null) {
      week = {};
    } else {
      week = tempweek;
    }

    for (var i = 0; i < 7; i++) {
      String key = (i + 1).toString();
      if (week[key] == null) {
        values[i] = -1;
      } else {
        values[i] = week[key]["Count"];
      }
    }

    getRange();
    getWeekSum();
    getMax();

    globalCountSum = dataController.getCountSum();
    globalPopulation = dataController.getPopulation();
  }

  void getMax() {
    int kMax = -1;
    for (int val in values) {
      if (val > kMax) {
        kMax = val;
      }
    }

    if (kMax > 0) {
      max = kMax;
    } else {
      max = 1;
    }
  }

  void moveBack() {
    if (weekoffset > 0) {
      weekoffset -= 1;
      getData();
    }
  }

  void moveForward() {
    if (weekoffset < weekgroup) {
      weekoffset += 1;
      getData();
    }
  }

  void moveToFirst() {
    weekoffset = 0;
    getData();
  }

  void moveToLast() {
    weekoffset = weekgroup;
    getData();
  }

  void getWeekSum() {
    int tsum = 0;
    int tpop = 0;
    for (int val in values) {
      if (val >= 0) {
        tsum += val;
        tpop += 1;
      }
    }

    sum = tsum;
    if (tpop > 0) {
      pop = tpop;
    }
  }

  void getRange() {
    DateTime firstdate = DateTime.parse(dataController.getFirstDate());
    DateTime start = firstdate
        .subtract(Duration(days: firstdate.weekday - 1))
        .add(Duration(days: 7 * weekoffset));
    DateTime end = start.add(const Duration(days: 6));

    String st = datetoString(start).replaceAll("-", "/");
    String ed = datetoString(end).replaceAll("-", "/");

    range = "$st  -  $ed";
  }
}
