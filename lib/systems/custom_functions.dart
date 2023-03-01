import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

List<int> toIntYMD({required String date}) {
  date = date.replaceAll("-", "");

  final int year = int.parse(date.substring(0, 4));
  final int month = int.parse(date.substring(4, 6));
  final int day = int.parse(date.substring(6, 8));

  return [year, month, day];
}

String toStr({required DateTime date}) {
  return date.toString().substring(0, 10);
}

bool _bigger(
    {required List<int> list1, required List<int> list2, bool equals = false}) {
  // [0] = year  [1] = month  [2] = day
  if (list1[0] > list2[0]) {
    return true;
  } else if (list1[0] < list2[0]) {
    return false;
  } else {
    if (list1[1] > list2[1]) {
      return true;
    } else if (list1[1] < list2[1]) {
      return false;
    } else {
      if (list1[2] > list2[2]) {
        return true;
      } else if (list1[2] < list2[2]) {
        return false;
      } else {
        return equals;
      }
    }
  }
}

String timetoString(DateTime dateTime, {clear = false}) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String strHour = hour.toString();
  String strMinute = minute.toString();

  if (hour < 10) {
    strHour = "0$strHour";
  }
  if (minute < 10) {
    strMinute = "0$strMinute";
  }

  if (clear) {
    return "$strHour$strMinute";
  }
  return "$strHour:$strMinute";
}

String datetoString(DateTime dateTime, {clean = false}) {
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;

  String strYear = year.toString();
  String strMonth = month.toString();
  String strDay = day.toString();

  if (month < 10) {
    strMonth = "0$strMonth";
  }
  if (day < 10) {
    strDay = "0$strDay";
  }

  if (clean) {
    return "$strYear$strMonth$strDay";
  }

  return "$strYear-$strMonth-$strDay";
}

bool dateIsBigger({
  required DateTime date1,
  required String date2,
  bool equals = false,
}) {
  List<int> list1 = toIntYMD(date: toStr(date: date1));
  List<int> list2 = toIntYMD(date: date2);

  return _bigger(list1: list1, list2: list2, equals: equals);
}

bool dateBiggerString({
  required String date1,
  required String date2,
  bool equals = false,
}) {
  List<int> list1 = toIntYMD(date: date1);
  List<int> list2 = toIntYMD(date: date2);

  return _bigger(list1: list1, list2: list2, equals: equals);
}

bool dateTimeIsBigger(DateTime datetime1, DateTime datetime2, {equal = false}) {
  int datetime1int = int.parse(datetoString(datetime1, clean: true));
  int datetime2int = int.parse(datetoString(datetime2, clean: true));

  if (equal) {
    return datetime1int >= datetime2int;
  } else {
    return datetime1int > datetime2int;
  }
}

void log({String title = "LOG", required var value}) {
  if (kDebugMode) {
    print("$title: $value");
  }
}

DateTime getDateTime(DataController dataController) {
  DateTime datenow = DateTime.now();
  String dayChangeTime = dataController.getDayChangeTime();
  if (dayChangeTime == dataController.defaultDayChangeTime) {
    return datenow;
  }

  String timeString = timetoString(datenow, clear: true);
  log(title: "Custom Function (getDateTime)", value: timeString);
  int time = int.parse(timeString);
  int changeTimeInt = int.parse(dataController.getDayChangeTime());

  if (0000 <= time && time < changeTimeInt) {
    return datenow.subtract(const Duration(days: 1));
  } else if (1200 <= changeTimeInt && 1200 <= time && time <= changeTimeInt) {
    return datenow.add(const Duration(days: 1));
  }

  return datenow;
}
