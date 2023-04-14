import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';
import 'package:smoking_regulator_v2/widgets/more_page/bottom_picker.dart';
import 'package:smoking_regulator_v2/widgets/more_page/settings_toggles/input_settings_togle.dart';
import 'package:smoking_regulator_v2/widgets/more_page/settings_toggles/settings_togle.dart';
import 'package:smoking_regulator_v2/widgets/more_page/history_view/time_table.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    Key? key,
    required this.changeColorMode,
    required this.changeAmoledMode,
    required this.factoredTimeString,
    required this.updateFactoredTime,
    required this.sunSetTimeString,
    required this.updateSunSetTime,
    required this.dailyLimit,
    required this.updateDailyLimit,
    required this.countController,
  }) : super(key: key);

  final Function() changeColorMode;
  final Function() changeAmoledMode;

  final String factoredTimeString;
  final Function({required String newFactoredTime}) updateFactoredTime;

  final String sunSetTimeString;
  final Function({required String newSunSetTime}) updateSunSetTime;

  final int dailyLimit;
  final Function({required int newDailyLimit}) updateDailyLimit;

  final CountController countController;

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
  }

  late List<int> factoredTime = const [0, 0];
  late List<int> sunSetTime = const [17, 30];

  @override
  Widget build(BuildContext context) {
    const String pageTitle = "More";

    // Size Assets
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double width = screenWidth * 0.84;
    final double height = screenHeight * 0.94;

    final double pageTitleHeight = height * 0.14;

    final double toggleHeight = height * 0.07;

    final double spaceBetween = height * 0.016;

    const double timetableHeightMultiplier = 0.275;

    factoredTime = parseStringTime(widget.factoredTimeString);
    sunSetTime = parseStringTime(widget.sunSetTimeString);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorProfiles.background(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: height * 0.072),
            height: 5 * toggleHeight +
                4 * spaceBetween +
                pageTitleHeight +
                height * 0.011 +
                height * 0.072,
            child: Column(
              children: [
                SizedBox(
                  height: pageTitleHeight,
                  child: Text(
                    pageTitle,
                    style: GoogleFonts.poppins(
                      color: ColorProfiles.text(),
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  title: "Color Mode",
                  value: CColors.colorMode(),
                  action: widget.changeColorMode,
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  title: "True Black",
                  value: CColors.isAmoled() ? "On" : "Off",
                  action: widget.changeAmoledMode,
                ),
                SizedBox(height: spaceBetween),
                InputToggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  title: "Daily Limit",
                  value: widget.dailyLimit.toString(),
                  action: (value) {
                    final String cleared = value
                        .trim()
                        .replaceAll(" ", "")
                        .replaceAll(".", "")
                        .replaceAll(",", "")
                        .replaceAll("-", "");

                    if (cleared != "") {
                      widget.updateDailyLimit(
                          newDailyLimit: int.parse(cleared));
                    }
                  },
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  title: "Day Change",
                  value: displayTime(factoredTime),
                  action: () {
                    showBottomTimePicker(
                        context: context,
                        initialTime: factoredTime,
                        title: "The hour at which the day changes:",
                        onSubmit: (value) {
                          setFactoredTime(timetoString(value));
                        });
                  },
                  secondaryAction: () {
                    setFactoredTime("00:00");
                  },
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  title: "Sun Set",
                  value: displayTime(sunSetTime),
                  action: () {
                    showBottomTimePicker(
                        context: context,
                        initialTime: sunSetTime,
                        title: "The hour at which the sun sets:",
                        onSubmit: (value) {
                          setSunSetTime(timetoString(value));
                        });
                  },
                  secondaryAction: () {
                    setSunSetTime("17:30");
                  },
                ),
              ],
            ),
          ),
          TimeTable(
            width: width,
            height: height * timetableHeightMultiplier,
            countController: widget.countController,
            background: ColorProfiles.box(),
            text: ColorProfiles.text(),
            divider: getColor(
              light: CColors.dark,
              dark: CColors.dark,
              amoled: CColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setFactoredTime(String value) async {
    widget.updateFactoredTime(newFactoredTime: value);
  }

  Future<void> setSunSetTime(String value) async {
    widget.updateSunSetTime(newSunSetTime: value);
  }

  String displayTime(List<int> time) {
    String hourString = time[0] == 0 ? "00" : time[0].toString();
    String minuteString = time[1] < 10 ? "0${time[1]}" : time[1].toString();

    return "$hourString:$minuteString";
  }

  List<int> parseStringTime(String time, {String? pattern}) {
    List<String> parts = time.split(pattern ?? ":");
    return [int.parse(parts[0]), int.parse(parts[1])];
  }
}
