import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/count_controller.dart';
import 'package:smoking_regulator_v2/systems/custom_colors.dart';
import 'package:smoking_regulator_v2/widgets/settings_togle.dart';
import 'package:smoking_regulator_v2/widgets/time_table.dart';
import 'package:tuple/tuple.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    Key? key,
    required this.colorMode,
    required this.isAmoled,
    required this.changeColorMode,
    required this.changeAmoledMode,
    required this.factoredTimeString,
    required this.updateFactoredTime,
    required this.updateSunSetTime,
    required this.countController,
  }) : super(key: key);

  final String colorMode;
  final bool isAmoled;
  final Function() changeColorMode;
  final Function() changeAmoledMode;

  final String factoredTimeString;
  final Function({required String newFactoredTime}) updateFactoredTime;
  final Function({required String newSunSetTime}) updateSunSetTime;

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

  late Tuple2 factoredTime = const Tuple2(0, 0);

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

    final String val = widget.factoredTimeString.replaceAll(":", "");
    final String val1 = val.substring(0, 2);
    final String val2 = val.substring(2, 4);
    factoredTime = Tuple2(int.parse(val1), int.parse(val2));

    return Scaffold(
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
                Toggle(
                  width: width,
                  active: false,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Daily Limit",
                  value: "5",
                  action: () {},
                  secondaryAction: () {},
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Day Change",
                  value: displayFactoredTime(),
                  action: () {
                    showBottomPicker(
                        context: context, initialTime: factoredTime);
                  },
                  secondaryAction: () {
                    setFactoredTime(value: "00:00");
                  },
                ),
                SizedBox(height: spaceBetween),
                Toggle(
                  width: width,
                  active: false,
                  toggleHeight: toggleHeight,
                  colorMode: widget.colorMode,
                  isAmoled: widget.isAmoled,
                  title: "Sun Set",
                  value: "17:00",
                  action: () {},
                  secondaryAction: () {},
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
    widget.updateFactoredTime(newFactoredTime: value.replaceAll(":", ""));
  }

  Future<void> setSunSetTime({required String value}) async {
    widget.updateFactoredTime(newFactoredTime: value.replaceAll(":", ""));
  }

  String displayFactoredTime() {
    int value1 = factoredTime.item1;
    int value2 = factoredTime.item2;

    String text1 = "$value1";
    String text2 = "$value2";

    if (value1 == 0) {
      text1 = "00";
    }

    if (value2 < 10) {
      text2 = "0$value2";
    }

    return "$text1:$text2";
  }

  void showBottomPicker(
      {required BuildContext context, required Tuple2 initialTime}) {
    BottomPicker.time(
      title: "The hour at which the day changes:",
      //                         ..., hour, minutes)
      initialDateTime: DateTime(
        0,
        0,
        0,
        initialTime.item1,
        initialTime.item2,
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
