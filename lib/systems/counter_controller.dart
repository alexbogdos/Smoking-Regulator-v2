import 'package:smoking_regulator_v2/systems/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

class CounterController {
  CounterController(
      {int value = 0, required int limit, required this.dataController}) {
    count = value;
    limit = limit;
  }

  final DataController dataController;
  final String date = getDatetoString(DateTime.now());
  late int count;
  late int limit;
  final List<String> timetable = [];

  void increase() {
    count += 1;
    String timeNow = getTimetoString(DateTime.now());
    timetable.add(timeNow);
  }

  void decrease() {
    if (count > 0) {
      count -= 1;
      timetable.removeLast();
    }
  }

  void save() {
    Map<String, dynamic> formatted = getSaveFormat();
    dataController.setData(key: date, value: formatted);
  }

  Map<String, dynamic> getSaveFormat() {
    return {"index": 0, "count": count, "timetable": timetable};
  }
}
