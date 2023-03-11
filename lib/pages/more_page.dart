import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_functions.dart';
import 'package:smoking_regulator_v2/widgets/more_page/settings_toggles/input_settings_togle.dart';
import 'package:smoking_regulator_v2/widgets/more_page/settings_toggles/settings_togle.dart';
import 'package:smoking_regulator_v2/widgets/more_page/history_view/time_table.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    Key? key,
    required this.colorMode,
    required this.isAmoled,
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

  final String colorMode;
  final bool isAmoled;
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
    // retrieveFactoredTime();
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

    final List<String> factoredTimeParts = widget.factoredTimeString.split(":");
    final int factoredTimeHour = int.parse(factoredTimeParts[0]);
    final int factoredTimeMinute = int.parse(factoredTimeParts[1]);
    factoredTime = [factoredTimeHour, factoredTimeMinute];

    final List<String> sunSetTimeParts = widget.sunSetTimeString.split(":");
    final int sunSetTimeHour = int.parse(sunSetTimeParts[0]);
    final int sunSetTimeMinute = int.parse(sunSetTimeParts[1]);
    sunSetTime = [sunSetTimeHour, sunSetTimeMinute];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.lightGrey,
        dark: CColors.dark,
        amoled: CColors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // color: Colors.red,
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
                      color: getColor(
                        colorMode: widget.colorMode,
                        isAmoled: widget.isAmoled,
                        light: CColors.dark,
                        dark: CColors.white,
                        amoled: CColors.white,
                      ),
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Color Mode",
                  value: widget.colorMode,
                  action: widget.changeColorMode,
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Amoled",
                  value: widget.isAmoled ? "On" : "Off",
                  action: widget.changeAmoledMode,
                ),
                SizedBox(height: spaceBetween),
                InputToggle(
                  // active: false,
                  width: width,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
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
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Day Change",
                  value: displayTime(factoredTime),
                  action: () {
                    showBottomPickerFactoredTime(
                        context: context, initialTime: factoredTime);
                  },
                  secondaryAction: () {
                    setFactoredTime(value: "00:00");
                  },
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Sun Set",
                  value: displayTime(sunSetTime),
                  action: () {
                    showBottomPickerSunSetTime(
                        context: context, initialTime: sunSetTime);
                  },
                  secondaryAction: () {
                    setSunSetTime(value: "17:30");
                  },
                ),
              ],
            ),
          ),
          TimeTable(
            width: width,
            height: height * timetableHeightMultiplier,
            countController: widget.countController,
            background: getColor(
              colorMode: widget.colorMode,
              isAmoled: widget.isAmoled,
              light: CColors.white,
              dark: CColors.darkGrey,
              amoled: CColors.dark,
            ),
            text: getColor(
              colorMode: widget.colorMode,
              isAmoled: widget.isAmoled,
              light: CColors.dark,
              dark: CColors.white,
              amoled: CColors.white,
            ),
            divider: getColor(
              colorMode: widget.colorMode,
              isAmoled: widget.isAmoled,
              light: CColors.dark,
              dark: CColors.dark,
              amoled: CColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setFactoredTime({required String value}) async {
    widget.updateFactoredTime(newFactoredTime: value);
  }

  Future<void> setSunSetTime({required String value}) async {
    widget.updateSunSetTime(newSunSetTime: value);
  }

  String displayTime(List<int> time) {
    int hour = time[0];
    int minute = time[1];

    String hourString = "$hour";
    String minuteString = "$minute";

    if (hour == 0) {
      hourString = "00";
    }

    if (minute < 10) {
      minuteString = "0$minute";
    }

    return "$hourString:$minuteString";
  }

  void showBottomPickerSunSetTime(
      {required BuildContext context, required List<int> initialTime}) {
    BottomPicker.time(
      title: "The hour at which the sun sets:",
      //                         ..., hour, minutes)
      initialDateTime: DateTime(
        0,
        0,
        0,
        initialTime[0],
        initialTime[1],
      ),
      titleStyle: GoogleFonts.poppins(
        color: getColor(
          colorMode: widget.colorMode,
          isAmoled: widget.isAmoled,
          light: CColors.dark,
          dark: CColors.white,
          amoled: CColors.white,
        ),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      use24hFormat: true,
      pickerTextStyle: GoogleFonts.poppins(
        color: getColor(
          colorMode: widget.colorMode,
          isAmoled: widget.isAmoled,
          light: CColors.dark,
          dark: CColors.white,
          amoled: CColors.white,
        ),
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      closeIconColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.dark,
        dark: CColors.white,
        amoled: CColors.lightGrey,
      ),
      iconColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.white,
        dark: CColors.dark,
        amoled: CColors.black,
      ),
      backgroundColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.white,
        dark: CColors.dark,
        amoled: Color.lerp(CColors.dark, CColors.black, 0.6) as Color,
      ),
      buttonSingleColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.dark,
        dark: CColors.white,
        amoled: CColors.lightGrey,
      ),
      onSubmit: (p1) {
        final String value = timetoString(p1);
        setSunSetTime(value: value);
      },
    ).show(context);
  }

  void showBottomPickerFactoredTime(
      {required BuildContext context, required List<int> initialTime}) {
    BottomPicker.time(
      title: "The hour at which the day changes:",
      //                         ..., hour, minutes)
      initialDateTime: DateTime(
        0,
        0,
        0,
        initialTime[0],
        initialTime[1],
      ),
      titleStyle: GoogleFonts.poppins(
        color: getColor(
          colorMode: widget.colorMode,
          isAmoled: widget.isAmoled,
          light: CColors.dark,
          dark: CColors.white,
          amoled: CColors.white,
        ),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      use24hFormat: true,
      pickerTextStyle: GoogleFonts.poppins(
        color: getColor(
          colorMode: widget.colorMode,
          isAmoled: widget.isAmoled,
          light: CColors.dark,
          dark: CColors.white,
          amoled: CColors.white,
        ),
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      closeIconColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.dark,
        dark: CColors.white,
        amoled: CColors.lightGrey,
      ),
      iconColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.white,
        dark: CColors.dark,
        amoled: CColors.black,
      ),
      backgroundColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.white,
        dark: CColors.dark,
        amoled: Color.lerp(CColors.dark, CColors.black, 0.6) as Color,
      ),
      buttonSingleColor: getColor(
        colorMode: widget.colorMode,
        isAmoled: widget.isAmoled,
        light: CColors.dark,
        dark: CColors.white,
        amoled: CColors.lightGrey,
      ),
      onSubmit: (p0) {
        final String value = p0.toString().substring(12, 17);
        setFactoredTime(value: value);
      },
    ).show(context);
  }
}
