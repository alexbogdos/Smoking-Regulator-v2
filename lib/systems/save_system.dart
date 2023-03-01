import 'dart:convert';
import 'dart:io';

// import 'package:path_provider/path_provider.dart';
import 'package:smoking_regulator_v2/systems/custom_functions.dart';

class SaveSystem {
  final String data = "user-data.json";
  final String settings = "user-setting.json";
  late String path = "/Smoking Regulator";

  Future<void> initializePath() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    Directory directory = Directory("/storage/emulated/0/Documents");
    path = "${directory.path}$path";
    // await createFiles();
  }

  // Future<void> createFiles() async {
  //   String completePathSetting = getCompleteFilename(settings);
  //   String completePathData = getCompleteFilename(data);

  //   if (await checkExistance(completePathSetting) == false) {
  //     File(completePathSetting).createSync(recursive: true);
  //     log(value: "Created $settings in $path");
  //   }
  //   if (await checkExistance(completePathData) == false) {
  //     File(completePathData).createSync(recursive: true);
  //     log(value: "Created $data in $path");
  //   }
  // }

  // Save counter data with counter.save(..) not with saveSystem.save(..)
  //
  // Saving Format: "2023-02-01": [index, count, [time1, time2, ..., timeX]]
  // Example: "2023-02-01": [2, 5, ["09:36", "12:48", "16:05", "16:15"]]
  Future<void> save({required String filename, required Map data}) async {
    String completeFilename = getCompleteFilename(filename);
    File file = File(completeFilename);

    log(
        title: "Save System (save)",
        value: "Save $filename at $completeFilename");

    String formatted = json.encode(data);
    file.writeAsString(formatted);
  }

  Future<Map<String, dynamic>?> load({required String filename}) async {
    String completeFilename = getCompleteFilename(filename);
    log(
        title: "Save System (load)",
        value: "Try load $filename at $completeFilename");
    bool exists = await checkExistance(completeFilename);
    if (!exists) {
      File(completeFilename).createSync(recursive: true);
      log(value: "Created $data in $path");
      return null;
    }

    File file = File(completeFilename);
    String source = await file.readAsString();
    if (source == "") {
      return null;
    }

    Map<String, dynamic>? rawdata = await json.decode(source);
    return rawdata;
  }

  Future<bool> checkExistance(String filepath) async {
    File file = File(filepath);
    bool exists = await file.exists();
    return exists;
  }

  String getCompleteFilename(String filename) {
    String p = "$path/$filename";
    return p;
  }
}
