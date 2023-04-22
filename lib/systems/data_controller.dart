import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';
import 'package:smoking_regulator_v2/systems/save_system.dart';

class DataController {
  static Map<String, dynamic> data = {};
  static Map<String, dynamic> settings = {};
  static Map<String, dynamic> week = {};

  // ----- Editing and Saving System ---------------
  Future<void> setData({
    required int weekGroup,
    required String key,
    required dynamic value,
  }) async {
    week[key] = value;
    data[weekGroup.toString()] = week;
    await SaveSystem.save(filename: SaveSystem.data, data: data);
  }

  dynamic getfromWeek({required String weekdayKey}) {
    return week[weekdayKey];
  }

  dynamic getfromData({int? weekgroupkey}) {
    if (weekgroupkey == null) {
      return data[getWeekGroup().toString()];
    }
    return data[weekgroupkey.toString()];
  }

  Future<void> setSetting({required String key, required dynamic value}) async {
    settings[key] = value;
    await SaveSystem.save(filename: SaveSystem.settings, data: settings);
  }

  dynamic getfromSettings({required String key}) {
    return settings[key];
  }

  // ----- Defaults ---------------
  String defaultColorMode = "Light";
  String getColorMode() {
    String value = getfromSettings(key: "Color Mode") ?? defaultColorMode;
    return value;
  }

  bool defaultAmoled = false;
  bool getAmoled() {
    bool value = getfromSettings(key: "Amoled") ?? defaultAmoled;
    return value;
  }

  String defaultDayChangeTime = "00:00";
  String getDayChangeTime() {
    String value =
        getfromSettings(key: "Day Change Time") ?? defaultDayChangeTime;
    return value;
  }

  String defaultSunSetTime = "17:30";
  String getSunSetTime() {
    String value = getfromSettings(key: "Sun Set Time") ?? defaultSunSetTime;
    return value;
  }

  int getStatsView() {
    return getfromSettings(key: "Stats View") ?? 0;
  }

  String getFirstDate() {
    String defaultValue = datetoString(getDateTime(this));
    if (getfromSettings(key: "First Date") == null) {
      setSetting(key: "First Date", value: defaultValue);
      return defaultValue;
    }

    return getfromSettings(key: "First Date");
  }

  String getLastDate() {
    String defaultValue = datetoString(getDateTime(this));
    if (getfromSettings(key: "Last Date") == null) {
      setSetting(key: "Last Date", value: defaultValue);
      return defaultValue;
    }

    return getfromSettings(key: "Last Date");
  }

  int getLastWeekDay() {
    if (getfromSettings(key: "Last Week Day") == null) {
      setSetting(key: "Last Week Day", value: 0);
      return 0;
    }

    return getfromSettings(key: "Last Week Day");
  }

  int getWeekGroup() {
    DateTime dtRaw = getDateTime(this);
    DateTime datenow = dtRaw.subtract(Duration(days: dtRaw.weekday - 1));

    DateTime firstdate = DateTime.parse(getFirstDate());
    DateTime firstWeekDate =
        firstdate.subtract(Duration(days: firstdate.weekday - 1));

    log(title: "Data Controller (getWeekGroup) fd", value: firstdate);
    log(
        title: "Data Controller (getWeekGroup) dn",
        value: DateTime(datenow.year, datenow.month, datenow.day));

    int difference = datenow.difference(firstWeekDate).inDays + 1;

    log(title: "Data Controller (getWeekGroup) diff", value: difference);

    log(title: "Data Controller (getWeekGroup) raw", value: difference / 7);

    int newWeekgroup = difference ~/ 7;

    log(title: "Data Controller (getWeekGroup)", value: newWeekgroup);

    return newWeekgroup;
  }

  Map<String, dynamic>? getDayData(String weekdayKey) {
    if (getfromWeek(weekdayKey: weekdayKey) == null) {
      return null;
    }

    log(
        title: "Data Controller (getDayData)",
        value: "$weekdayKey : ${getfromWeek(weekdayKey: weekdayKey)}");
    return getfromWeek(weekdayKey: weekdayKey);
  }

  int getCountSum() {
    if (getfromSettings(key: "Count Sum") == null) {
      setSetting(key: "Count Sum", value: 0);
      return 0;
    }

    return getfromSettings(key: "Count Sum");
  }

  int getPopulation() {
    if (getfromSettings(key: "Population") == null) {
      setSetting(key: "Population", value: 1);
      return 1;
    }

    return getfromSettings(key: "Population");
  }

  int defaultLimit = 5;
  int getLimit() {
    if (getfromSettings(key: "Daily Limit") == null) {
      setSetting(key: "Daily Limit", value: defaultLimit);
      return defaultLimit;
    }

    return getfromSettings(key: "Daily Limit");
  }

  // ----- Loading System ---------------
  Future<void> load() async {
    await SaveSystem.initializePath();
    await loadSettings();
    await loadData();
  }

  Future<void> loadSettings() async {
    Map<String, dynamic>? tempSettings =
        await SaveSystem.load(filename: SaveSystem.settings);

    if (tempSettings != null) {
      settings = tempSettings;
      log(title: "Data Controller (loadSettings)", value: "Settings Loaded");
    } else {
      settings = {};
      log(title: "Data Controller (loadSettings)", value: "Did not load");
    }
  }

  Future<void> loadData() async {
    await performChecks();

    Map<String, dynamic>? tempData =
        await SaveSystem.load(filename: SaveSystem.data);

    if (tempData != null) {
      data = tempData;
      Map<String, dynamic>? tempWeek = getfromData();
      if (tempWeek == null) {
        week = {};
        log(title: "Data Controller (loadData)", value: "Did not load");
      } else {
        week = tempWeek;
        // log(title: "Data Controller (loadData)", value: "Current Week: $week");
        log(title: "Data Controller (loadData)", value: "Data Loaded");
      }
      log(title: "Data Controller (loadData)", value: data);
    } else {
      data = {};
      log(title: "Data Controller (loadData)", value: "Did not load");
    }
  }

  // ----- Checks ---------------
  Future<void> performChecks() async {
    checkPopulation();
    checkLastDate();

    log(title: "Data Controller (performChecks)", value: "Checks Performed");
  }

  void checkPopulation() {
    DateTime datenow = getDateTime(this);
    DateTime lastdate = DateTime.parse(getLastDate());

    bool isAfter = dateTimeIsBigger(datenow, lastdate);
    int popvalue = getPopulation();
    if (isAfter) {
      setSetting(key: "Population", value: popvalue + 1);
    }
  }

  void checkLastDate() {
    DateTime datenow = getDateTime(this);
    DateTime lastdate = DateTime.parse(getLastDate());

    bool isAfter = dateTimeIsBigger(datenow, lastdate);
    if (isAfter) {
      setSetting(key: "Last Date", value: datetoString(datenow));
    }
    log(title: "Data Controller (checkLastDate)", value: datetoString(datenow));
  }
}
