import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smoking_regulator_v2/systems/helpers/custom_colors.dart';

void showBottomTimePicker({
  required BuildContext context,
  required List<int> initialTime,
  required String title,
  required Function(dynamic) onSubmit,
}) {
  BottomPicker.time(
    title: title,
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
        light: CColors.dark,
        dark: CColors.white,
        amoled: CColors.white,
      ),
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    closeIconColor: getColor(
      light: CColors.dark,
      dark: CColors.white,
      amoled: CColors.lightGrey,
    ),
    iconColor: getColor(
      light: CColors.white,
      dark: CColors.dark,
      amoled: CColors.black,
    ),
    backgroundColor: getColor(
      light: CColors.white,
      dark: CColors.dark,
      amoled: Color.lerp(CColors.dark, CColors.black, 0.6) as Color,
    ),
    buttonSingleColor: getColor(
      light: CColors.dark,
      dark: CColors.white,
      amoled: CColors.lightGrey,
    ),
    onSubmit: onSubmit,
  ).show(context);
}
