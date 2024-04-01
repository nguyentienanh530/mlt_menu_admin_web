// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/utils.dart';

class CommonTextStyle {
  // final BuildContext? context;

  // CommonTextStyle({required this.context});
  static TextStyle light(
      {double? fontSize, Color? textColor, FontStyle? fontStyle}) {
    // return context!.textStyleSmall!;

    return GoogleFonts.nunito(
        textStyle: TextStyle(
            color: textColor ?? kTextColor,
            fontStyle: fontStyle,
            fontWeight: FontWeight.w300,
            fontSize: fontSize ?? kTextSizeSmall));
  }

  static TextStyle normal(
      {double? fontSize, Color? textColor, FontStyle? fontStyle}) {
    return GoogleFonts.nunito(
        textStyle: TextStyle(
            color: textColor ?? kTextColor,
            fontStyle: fontStyle,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? kTextSizeSmall));
  }

  static TextStyle bold(
      {double? fontSize, Color? textColor, FontStyle? fontStyle}) {
    return GoogleFonts.nunito(
        textStyle: TextStyle(
            color: textColor ?? kTextColor,
            fontStyle: fontStyle,
            fontWeight: FontWeight.w900,
            fontSize: fontSize ?? kTextSizeSmall));
  }
}
