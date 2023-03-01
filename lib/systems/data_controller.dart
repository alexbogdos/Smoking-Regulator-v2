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

  Future<void> setSettings(
      {required String key, required dynamic value}) async {
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

  String defaultFirstDate = getDatetoString(DateTime.now());
  String getFirstDate() {
    if (getfromData(key: "FirstDate") == null) {
      setData(key: "FirstDate", value: defaultFirstDate);
      return defaultFirstDate;
    }

    return getfromData(key: "FirstDate");
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
}
