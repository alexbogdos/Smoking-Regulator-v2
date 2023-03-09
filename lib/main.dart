import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smoking_regulator_v2/systems/calendar_controller.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/custom_colors.dart';
import 'package:smoking_regulator_v2/pages/more_page.dart';
import 'package:smoking_regulator_v2/pages/home_page.dart';
import 'package:smoking_regulator_v2/systems/data_controller.dart';

void main() {
  runApp(const MaterialApp(
    home: MainPage(),
    debugShowCheckedModeBanner: false,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Data Controller
  final DataController dataController = DataController();

  // Count Controller
  late CountController countController;

  // Count Controller
  late CalendarController calendarController;

  // Page Controller for scroling between the MainPage and MorePage
  final PageController pageController = PageController(initialPage: 0);

  // Keep check if data finished loading
  late bool loaded = false;

  @override
  void initState() {
    super.initState();
    grantPermissions().then(
        (value) => dataController.load().then((value) => finishLoading()));
  }

  void updateCounter() {
    void refreshState() {
      setState(() {
        calendarController = CalendarController(dataController: dataController);
        countController = CountController(dataController: dataController);
      });
    }

    dataController.performChecks().then((value) => refreshState());
  }

  void finishLoading() {
    setState(() {
      colorMode = dataController.getColorMode();
      amoled = dataController.getAmoled();
      dayChangeTime = dataController.getDayChangeTime();

      calendarController = CalendarController(dataController: dataController);
      countController = CountController(dataController: dataController);

      loaded = true;
    });
  }

  Future<void> grantPermissions() async {
    if (Platform.isAndroid) {
      // bool granted = await Permission.accessMediaLocation.request().isGranted;
      // while (!granted) {
      //   granted = await Permission.accessMediaLocation.request().isGranted;
      // }

      bool granted = await Permission.manageExternalStorage.request().isGranted;
      while (!granted) {
        granted = await Permission.manageExternalStorage.request().isGranted;
      }

      // granted = await Permission.storage.request().isGranted;
      // while (!granted) {
      //   granted = await Permission.storage.request().isGranted;
      // }
    }
  }

  void changeColorMode() {
    setState(() {
      String tempColorMode = dataController.getColorMode();
      colorMode = cycleColorMode(colorMode: tempColorMode);
      dataController.setSetting(key: "ColorMode", value: colorMode);
    });
  }

  void changeAmoledMode() {
    setState(() {
      bool tempAmoled = dataController.getAmoled();
      amoled = !tempAmoled;
      dataController.setSetting(key: "Amoled", value: amoled);
    });
  }

  void updateFactoredTime({required String newFactoredTime}) {
    setState(() {
      dayChangeTime = newFactoredTime;
      dataController
          .setSetting(key: "DayChangeTime", value: dayChangeTime)
          .then((value) => updateCounter());
    });
  }

  void updateSunSetTime({required String newSunSetTime}) {
    setState(() {
      sunSetTime = newSunSetTime;
      dataController.setSetting(key: "SunSetTime", value: dayChangeTime);
    });
  }

  // Build Assets
  late String colorMode = dataController.defaultColorMode;
  late bool amoled = dataController.defaultAmoled;
  late String dayChangeTime = dataController.defaultDayChangeTime;
  late String sunSetTime = dataController.defaultSunSetTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.black,
      body: Center(
        child: loaded
            ? PageView(
                controller: pageController,
                children: [
                  HomePage(
                    colorMode: colorMode,
                    isAmoled: amoled,
                    factoredTime: dayChangeTime,
                    firstDate: dataController.getFirstDate(),
                    dataController: dataController,
                    calendarController: calendarController,
                    countController: countController,
                  ),
                  MorePage(
                    colorMode: colorMode,
                    isAmoled: amoled,
                    changeColorMode: changeColorMode,
                    changeAmoledMode: changeAmoledMode,
                    factoredTimeString: dayChangeTime,
                    updateFactoredTime: updateFactoredTime,
                    updateSunSetTime: updateSunSetTime,
                    countController: countController,
                  )
                ],
              )
            : const CircularProgressIndicator(
                color: CColors.white,
              ),
      ),
    );
  }
}
