import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoking_regulator_v2/custom_colors.dart';
import 'package:smoking_regulator_v2/more_page.dart';
import 'package:smoking_regulator_v2/widgets/button.dart';
import 'package:smoking_regulator_v2/widgets/calendar.dart';
import 'package:smoking_regulator_v2/widgets/counter.dart';
import 'package:smoking_regulator_v2/widgets/info_tab.dart';
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
  @override
  void initState() {
    super.initState();
    retrieveColorMode();
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

  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: pageController,
          children: [
            HomePage(darkMode: darkMode),
            MorePage(
              darkMode: darkMode,
              changeColorMode: changeColorMode,
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.darkMode}) : super(key: key);
  final bool darkMode;

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

    // print("W: $screenWidth  H: $screenHeight");

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

    final bool darkMode = widget.darkMode;
    return Scaffold(
        backgroundColor:
            darkMode == false ? CColors.lightGrey : CColors.darkGrey,
        body: Align(
          alignment: const Alignment(0, 0.3),
          child: SizedBox(
            // color: Colors.red.withOpacity(0.4),
            width: width,
            height: height,
            child: Column(
              children: [
                PageTitle(
                  width: width,
                  height: pageTitleHeight,
                  textColor: darkMode == false ? CColors.black : CColors.white,
                ),
                SizedBox(height: height * 0.03),
                Stats(
                  key: statsState,
                  infoTabWidth: infoTabWidth,
                  infoTabHeight: infoTabHeight,
                  darkMode: darkMode,
                ),
                SizedBox(height: height * 0.03),
                Counter(
                  key: counterkey,
                  width: counterWidth,
                  height: counterHeight,
                  textColor: darkMode == false ? CColors.black : CColors.white,
                  subTextColor:
                      darkMode == false ? CColors.darkGrey : CColors.lightGrey,
                  setSum: (int sum) {
                    statsState.currentState!.setSum(sumValue: sum);
                  },
                  setPopulation: (int population) {
                    statsState.currentState!
                        .setPopulation(populationValue: population);
                  },
                ),
                SizedBox(height: height * 0.05),
                Calendar(
                  key: calendarkey,
                  width: calendarWidth,
                  height: calendarHeight,
                  background: darkMode == false ? CColors.white : CColors.black,
                  fill: darkMode == false ? CColors.black : CColors.white,
                  disabled:
                      darkMode == false ? CColors.darkGrey : CColors.lightGrey,
                ),
                SizedBox(height: height * 0.06),
                Button(
                  width: buttonWidth,
                  height: buttonHeight,
                  background: darkMode == false ? CColors.white : CColors.black,
                  textColor: darkMode == false ? CColors.black : CColors.white,
                  fill:
                      darkMode == false ? CColors.darkGrey : CColors.lightGrey,
                  increase: () {
                    counterkey.currentState!.increase();
                  },
                  decrease: () {
                    counterkey.currentState!.decrease();
                  },
                  refreshCalendar: () {
                    calendarkey.currentState!.refresh();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class Stats extends StatefulWidget {
  const Stats({
    Key? key,
    required this.infoTabWidth,
    required this.infoTabHeight,
    required this.darkMode,
  }) : super(key: key);

  final double infoTabWidth;
  final double infoTabHeight;
  final bool darkMode;

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    retrieveSum().then((value) => retrievePopulation());
  }

  late int sum = 0;
  late int population = 1;

  Future<void> retrieveSum() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("Sum")) {
      final int? value = prefs.getInt("Sum");

      if (value != null) {
        sum = value;
        return;
      }
    } else {}
  }

  Future<void> retrievePopulation() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    if (prefs.containsKey("Population")) {
      final int? value = prefs.getInt("Population");
      if (value != null) {
        population = value;

        if (prefs.containsKey("LastDate")) {
          final String? lastDate = prefs.getString("LastDate");
          if (lastDate != DateTime.now().toString().substring(0, 10)) {
            await prefs.setInt("Population", value + 1);
            await prefs.setString(
                "LastDate", DateTime.now().toString().substring(0, 10));
            population = value + 1;
          }
          // else {
          //   // await prefs.setInt("Population", value - 1);
          //   setPopulation((value));
          // }
        } else {
          await prefs.setString(
              "LastDate", DateTime.now().toString().substring(0, 10));
        }

        setState(() {});
        return;
      }
    }
  }

  void setSum({required int sumValue}) {
    setState(() {
      sum = sumValue;
    });
  }

  void setPopulation({required int populationValue}) {
    setState(() {
      population = populationValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoTab(
          width: widget.infoTabWidth,
          height: widget.infoTabHeight,
          boxColor: widget.darkMode == false ? CColors.white : CColors.black,
          textColor: widget.darkMode == false ? CColors.black : CColors.white,
          title: "Day\nAverage",
          value: (sum / population).round(),
        ),
        InfoTab(
          width: widget.infoTabWidth,
          height: widget.infoTabHeight,
          boxColor: widget.darkMode == false ? CColors.white : CColors.black,
          textColor: widget.darkMode == false ? CColors.black : CColors.white,
          title: "Week\nAverage",
          value: (sum / population).round() * 7,
        ),
        InfoTab(
          width: widget.infoTabWidth,
          height: widget.infoTabHeight,
          boxColor: widget.darkMode == false ? CColors.white : CColors.black,
          textColor: widget.darkMode == false ? CColors.black : CColors.white,
          title: "Month\nAverage",
          value: (sum / population).round() * 30,
        ),
      ],
    );
  }
}
