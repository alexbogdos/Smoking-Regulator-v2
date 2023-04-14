import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';

class SaveSystem {
  static String data = "userdata.json";
  static String settings = "usersetting.json";
  static String path = "/Smoking Regulator";

  static Future<void> initializePath() async {
    if (Platform.isAndroid) {
      Directory directory = Directory("/storage/emulated/0/Documents");
      path = "${directory.path}$path";
      return;
    }

    Directory directory = await getApplicationDocumentsDirectory();
    path = "${directory.path}$path";
  }

  static Future<void> save(
      {required String filename, required Map data}) async {
    String completeFilename = getCompleteFilename(filename);
    File file = File(completeFilename);

    log(
        title: "Save System (save)",
        value: "Save $filename at $completeFilename");

    String formatted = json.encode(data);
    file.writeAsString(formatted);
  }

  static Future<Map<String, dynamic>?> load({required String filename}) async {
    String completeFilename = getCompleteFilename(filename);
    log(
        title: "Save System (load)",
        value: "Try load $filename at $completeFilename");
    bool exists = await checkExistance(completeFilename);
    if (!exists) {
      File(completeFilename).createSync(recursive: true);
      log(title: "Save System (load)", value: "Created $data in $path");
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

  static Future<bool> checkExistance(String filepath) async {
    File file = File(filepath);
    bool exists = await file.exists();
    return exists;
  }

  static String getCompleteFilename(String filename) {
    return "$path/$filename";
  }
}
