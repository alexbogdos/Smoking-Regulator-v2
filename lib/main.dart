import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Page Controller for scroling between the MainPage and MorePage
  final PageController pageController = PageController(initialPage: 0);

  // Keep check if data finished loading
  late bool loaded = false;

  @override
  void initState() {
    super.initState();
    grantPermissions().then((value) => dataController.load().then((value) =>
        dataController.performChecks().then((value) => finishLoading())));
  }

  void updateCounter() {
    void refreshState() {
      setState(() {
        int limit = dataController.getLimit();

        countController = CountController(
          limit: limit,
          dataController: dataController,
        );
      });
    }

    dataController.performChecks().then((value) => refreshState());
  }

  void finishLoading() {
    setState(() {
      colorMode = dataController.getColorMode();
      amoled = dataController.getAmoled();
      dayChangeTime = dataController.getDayChangeTime();

      int limit = dataController.getLimit();
      countController = CountController(
        limit: limit,
        dataController: dataController,
      );

      loaded = true;
    });
  }

  Future<void> grantPermissions() async {
    // if (Platform.isAndroid) {
    //   bool granted = await Permission.accessMediaLocation.request().isGranted;
    //   while (!granted) {
    //     granted = await Permission.accessMediaLocation.request().isGranted;
    //   }
    // }
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

  // Build Assets
  late String colorMode = dataController.defaultColorMode;
  late bool amoled = dataController.defaultAmoled;
  late String dayChangeTime = dataController.defaultDayChangeTime;

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
                    countController: countController,
                    dataController: dataController,
                  ),
                  MorePage(
                    colorMode: colorMode,
                    isAmoled: amoled,
                    changeColorMode: changeColorMode,
                    changeAmoledMode: changeAmoledMode,
                    factoredTimeString: dayChangeTime,
                    updateFactoredTime: updateFactoredTime,
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
