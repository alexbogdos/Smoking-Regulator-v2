import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoking_regulator_v2/custom_colors.dart';
import 'package:smoking_regulator_v2/more_page.dart';
import 'package:smoking_regulator_v2/widgets/button.dart';
import 'package:smoking_regulator_v2/widgets/calendar.dart';
import 'package:smoking_regulator_v2/widgets/counter.dart';
import 'package:smoking_regulator_v2/widgets/stats.dart';
import 'package:smoking_regulator_v2/widgets/title.dart';

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
  // Page Controller for scroling between the MainPage and MorePage
  final PageController pageController = PageController(initialPage: 0);
  // factoredTime: contains the time at which the day
  // should change
  late String factoredTime = "0000";

  // Related with the asychornous loading of the data
  late int progressDone = 0;
  late bool loaded = false;

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  // Increase the @progressDone, meaning that an asychronous
  // function is completed
  void increaseProgress() {
    progressDone += 1;

    if (progressDone == 2) {
      setState(() {
        //! loaded = true;
        loaded = true;
      });
    }
  }

  Future<void> retrieveData() async {
    retrieveColorMode().then((value) => increaseProgress());
    retrieveFactoredTime().then((value) => increaseProgress());
  }

  // Color Settings
  Future<void> retrieveColorMode() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("ColorMode")) {
      final bool? value = prefs.getBool("ColorMode");
      if (value != null) {
        setState(() {
          darkMode = value;
        });
      }
    }
  }

  Future<void> saveColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ColorMode", darkMode);
  }

  late bool darkMode = false;
  void changeColorMode() {
    setState(() {
      darkMode = !darkMode;
      saveColorMode();
    });
  }

  // Change Day Time Settings
  Future<void> retrieveFactoredTime() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("Factored Time")) {
      final String? value = prefs.getString("Factored Time");

      if (value != null) {
        factoredTime = value.replaceAll(":", "");
      }
    }

    setState(() {});
  }

  void updateFactoredTime({required String newFactoredTime}) {
    setState(() {
      factoredTime = newFactoredTime;
    });
  }

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
                    darkMode: darkMode,
                    factoredTime: factoredTime,
                  ),
                  MorePage(
                    darkMode: darkMode,
                    changeColorMode: changeColorMode,
                    factoredTimeString: factoredTime,
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.darkMode, required this.factoredTime})
      : super(key: key);
  final bool darkMode;
  final String factoredTime;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<CounterState> counterkey = GlobalKey();
  final GlobalKey<CalendarState> calendarkey = GlobalKey();
  final GlobalKey<StatsState> statsState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Size Assets
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double width = screenWidth * 0.84;
    final double height = screenHeight * 0.94;

    final double pageTitleHeight = height * 0.14;

    final double infoTabWidth = width * 0.3;
    final double infoTabHeight = height * 0.16;

    final double counterWidth = width;
    final double counterHeight = height * 0.16;

    final double calendarWidth = width;
    final double calendarHeight = height * 0.22;

    final double buttonWidth = width;
    final double buttonHeight = height * 0.1;

    // Color Mode Assets
    final bool darkMode = widget.darkMode;
    return Scaffold(
      backgroundColor: getColor(darkMode, CColors.lightGrey, CColors.black),
      body: Align(
        alignment: const Alignment(0, 0.3),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              PageTitle(
                width: width,
                height: pageTitleHeight,
                textColor: getColor(darkMode, CColors.black, CColors.white),
              ),
              SizedBox(height: height * 0.01),
              Stats(
                key: statsState,
                infoTabWidth: infoTabWidth,
                infoTabHeight: infoTabHeight,
                darkMode: darkMode,
              ),
              SizedBox(height: height * 0.05),
              Counter(
                key: counterkey,
                width: counterWidth,
                height: counterHeight,
                textColor: getColor(darkMode, CColors.black, CColors.white),
                subTextColor:
                    getColor(darkMode, CColors.darkGrey, CColors.lightGrey),
                setSum: (int sum) {
                  statsState.currentState!.setSum(sumValue: sum);
                },
                setPopulation: (int population) {
                  statsState.currentState!
                      .setPopulation(populationValue: population);
                },
                factoredTime: widget.factoredTime,
              ),
              SizedBox(height: height * 0.03),
              Calendar(
                key: calendarkey,
                width: calendarWidth,
                height: calendarHeight,
                background: getColor(darkMode, CColors.white, CColors.darkGrey),
                fill: getColor(darkMode, CColors.black, CColors.white),
                disabled:
                    getColor(darkMode, CColors.darkGrey, CColors.lightGrey),
                factoredTime: widget.factoredTime,
              ),
              SizedBox(height: height * 0.06),
              Button(
                width: buttonWidth,
                height: buttonHeight,
                background: getColor(darkMode, CColors.white, CColors.darkGrey),
                textColor: getColor(darkMode, CColors.black, CColors.white),
                fill: getColor(darkMode, CColors.darkGrey, CColors.lightGrey),
                increase: () {
                  counterkey.currentState!.increase();
                },
                decrease: () {
                  counterkey.currentState!.decrease();
                },
                refreshCalendar: ({bool forceBuild = false}) {
                  calendarkey.currentState!.refresh(forceBuild: forceBuild);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
