import 'package:smoking_regulator_v2/systems/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/save_system.dart';

class DataController {
  late Map<String, dynamic> data = {};
  late Map<String, dynamic> settings = {};
  final SaveSystem saveSystem = SaveSystem();

  // ----- Editing and Saving System ---------------
  Future<void> setData({required String key, required dynamic value}) async {
    data[key] = value;
    await saveSystem.save(filename: saveSystem.data, data: data);
  }

  dynamic getfromData({required String key}) {
    return data[key];
  }

  Future<void> setSetting({required String key, required dynamic value}) async {
    settings[key] = value;
    await saveSystem.save(filename: saveSystem.settings, data: settings);
  }

  dynamic getfromSettings({required String key}) {
    return settings[key];
  }

  // ----- Defaults ---------------
  String defaultColorMode = "Light";
  String getColorMode() {
    String value = getfromSettings(key: "ColorMode") ?? defaultColorMode;
    return value;
  }

  bool defaultAmoled = false;
  bool getAmoled() {
    bool value = getfromSettings(key: "Amoled") ?? defaultAmoled;
    return value;
  }

  String defaultDayChangeTime = "0000";
  String getDayChangeTime() {
    String value =
        getfromSettings(key: "DayChangeTime") ?? defaultDayChangeTime;
    return value;
  }

  String getFirstDate() {
    String defaultValue = datetoString(getDateTime(this));
    if (getfromSettings(key: "FirstDate") == null) {
      setSetting(key: "FirstDate", value: defaultValue);
      return defaultValue;
    }

    return getfromSettings(key: "FirstDate");
  }

  String getLastDate() {
    String defaultValue = datetoString(getDateTime(this));
    if (getfromSettings(key: "LastDate") == null) {
      setSetting(key: "LastDate", value: defaultValue);
      return defaultValue;
    }

    return getfromSettings(key: "LastDate");
  }

  int getLastWeekDay() {
    if (getfromSettings(key: "LastWeekDay") == null) {
      setSetting(key: "LastWeekDay", value: 0);
      return 0;
    }

    return getfromSettings(key: "LastWeekDay");
  }

  int getWeekGroup() {
    if (getfromSettings(key: "WeekGroup") == null) {
      setSetting(key: "WeekGroup", value: 0);
      return 0;
    }

    return getfromSettings(key: "WeekGroup");
  }

  Map<String, dynamic>? getDayData(String date) {
    if (getfromData(key: date) == null) {
      return null;
    }

    log(
        title: "Data Controller (getDayData)",
        value: "$date : ${getfromData(key: date)}");
    return getfromData(key: date);
  }

  int getCountSum() {
    if (getfromSettings(key: "CountSum") == null) {
      setSetting(key: "CountSum", value: 0);
      return 0;
    }

    return getfromSettings(key: "CountSum");
  }

  int defaultLimit = 5;
  int getLimit() {
    if (getfromSettings(key: "limit") == null) {
      setSetting(key: "limit", value: defaultLimit);
      return defaultLimit;
    }

    return getfromSettings(key: "limit");
  }

  // ----- Loading System ---------------
  Future<void> load() async {
    await saveSystem.initializePath();
    await loadSettings();
    await loadData();
  }

  Future<void> loadSettings() async {
    Map<String, dynamic>? tempSettings =
        await saveSystem.load(filename: saveSystem.settings);

    if (tempSettings != null) {
      settings = tempSettings;
      log(title: "Data Controller (loadSettings)", value: "Operation Succeded");
    } else {
      settings = {};
      log(title: "Data Controller (loadSettings)", value: "Did not load");
    }
  }

  Future<void> loadData() async {
    Map<String, dynamic>? tempData =
        await saveSystem.load(filename: saveSystem.data);

    if (tempData != null) {
      data = tempData;
      log(title: "Data Controller (loadData)", value: "Operation Succeded");
    } else {
      data = {};
      log(title: "Data Controller (loadData)", value: "Did not load");
    }
  }

  // ----- Checks ---------------
  Future<void> performChecks() async {
    checkWeekGroup();
  }

  void checkWeekGroup() {
    int weekday = getDateTime(this).weekday;
    String lastDate = getLastDate();

    bool weekdayIsBefore = weekday <= getLastWeekDay();
    bool datesDifferent =
        dateTimeIsBigger(getDateTime(this), DateTime.parse(lastDate));
    if (weekdayIsBefore && datesDifferent) {
      int group = getWeekGroup() + 1;
      setSetting(key: "WeekGroup", value: group);
    }
  }
}
