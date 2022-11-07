import 'package:flutter/foundation.dart';

class DTools {
  bool intIsBigger({
    required int number1,
    required int number2,
    bool equals = true,
  }) {
    if (equals) {
      return number1 >= number2;
    }
    return number1 > number2;
  }

  int stringDateToInt({required String date}) {
    date = date.replaceAll("-", "");

    return int.parse(date);
  }

  String dateToString({required DateTime date}) {
    return date.toString().substring(0, 10);
  }

  bool dateIsBigger({
    required DateTime date1,
    required String date2,
    bool equals = false,
  }) {
    int val2 = stringDateToInt(date: dateToString(date: date1));
    int val1 = stringDateToInt(date: date2);

    log(
      title: "DateTime.now() > lastDate",
      value: "intIsBigger(number1: val1, number2: val2, equals: equals)",
    );

    return intIsBigger(number1: val1, number2: val2, equals: equals);
  }
}

void log({String title = "LOG", required var value}) {
  if (kDebugMode) {
    print("$title: $value");
  }
}
