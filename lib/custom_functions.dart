import 'package:flutter/foundation.dart';

class DTools {
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

  bool dateIsBigger({
    required DateTime date1,
    required String date2,
    bool equals = false,
  }) {
    List<int> list1 = toIntYMD(date: toStr(date: date1));
    List<int> list2 = toIntYMD(date: date2);

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
}

void log({String title = "LOG", required var value}) {
  if (kDebugMode) {
    print("$title: $value");
  }
}
