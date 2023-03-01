import 'package:smoking_regulator_v2/systems/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

class CountController {
  CountController({
    required this.limit,
    required this.dataController,
  }) {
    String date = datetoString(getDateTime(dataController));
    Map<String, dynamic>? dayData = dataController.getDayData(date);
    count = dayData?["count"] ?? 0;
    timetable = dayData?["timetable"] ?? [];
    countSum = dataController.getCountSum();
    save();
  }

  final DataController dataController;
  late int count;
  late int countSum;
  late int limit;
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
    Map<String, dynamic> formatted = getSaveFormat();
    log(
        title: "Counter Controller (save)",
        value: "${getDateTime(dataController)} $formatted");
    String date = datetoString(getDateTime(dataController));
    dataController.setData(key: date, value: formatted);
    dataController.setSetting(key: "CountSum", value: countSum);
  }

  Map<String, dynamic> getSaveFormat() {
    return {
      "weekgroup": dataController.getWeekGroup(),
      "weekday": getDateTime(dataController).weekday,
      "count": count,
      "timetable": timetable
    };
  }
}
