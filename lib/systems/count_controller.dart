import 'package:smoking_regulator_v2/systems/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

Map<int, String> dayNames = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};

class CountController {
  CountController({
    required this.dataController,
  }) {
    limit = dataController.getLimit();

    DateTime datenow = getDateTime(dataController);
    String key = datenow.weekday.toString();
    Map<String, dynamic>? dayData = dataController.getDayData(key);
    count = dayData?["Count"] ?? 0;
    timetable = dayData?["TimeTable"] ?? [];
    countSum = dataController.getCountSum();
    weekGroup = dataController.getWeekGroup();

    if (dayData == null) {
      save();
    }
  }

  final DataController dataController;
  late int count;
  late int countSum;
  late int limit;
  late int weekGroup;
  late List<dynamic> timetable;

  void increase() {
    count += 1;
    countSum += 1;
    String timeNow = timetoString(getDateTime(dataController));
    timetable.add(timeNow);
    save();
  }

  void decrease() {
    if (count > 0) {
      count -= 1;
      countSum -= 1;
      if (timetable.isNotEmpty) {
        timetable.removeLast();
      }
      save();
    }
  }

  void save() {
    DateTime datenow = getDateTime(dataController);
    Map<String, dynamic> formatted = getSaveFormat(datenow);
    String key = datenow.weekday.toString();
    log(
        title: "Count Controller (save)",
        value: "${datetoString(datenow)} ${datenow.weekday}: $formatted");
    dataController.setData(weekGroup: weekGroup, key: key, value: formatted);
    dataController.setSetting(key: "CountSum", value: countSum);
  }

  Map<String, dynamic> getSaveFormat(DateTime date) {
    return {
      "Date": datetoString(date),
      "Day": dayNames[date.weekday],
      "WeekGroup": weekGroup,
      "Count": count,
      "TimeTable": timetable,
    };
  }
}
