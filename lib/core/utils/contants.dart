import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// var lstFoodInCart = <FoodModel>[];

enum Mode { create, update }

// Size Text
double kTextSizeSmall = 12.0;
double kTextSizeMedium = 16.0;
double kTextSizeLarge = 20.0;

// Border
double defaultBorderRadius = 16;

// padding
double defaultPadding = 16;

// Colors
Color kTextColor = Colors.white;
Color kWhiteColor = Colors.white;
Color kSecondaryTextColor = Colors.white70;

Color kRedColor = Colors.red;
Color kGreenColor = Colors.lightGreen.shade800;
Color kYellowColor = Colors.yellowAccent;
Color kBackgroundColor = const Color(0xFF1E2026);
Color kPrimaryColor = const Color(0xFF23252E);
Color kAccentColor = const Color(0xFFFF975D);
Color kBlackColor = const Color(0xFF1E2026);
Color dialogColor = "#383838".toColor();

final logger = Logger();

// Orientation
extension GetOrirntation on BuildContext {
  Orientation get orientation => MediaQuery.of(this).orientation;
}

// NoImage
String noImage =
    "https://firebasestorage.googleapis.com/v0/b/mlt-son.appspot.com/o/noImage.png?alt=media&token=039f7f7e-889d-4d47-b6de-c8636f5e28f6";

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
