import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get _theme => Theme.of(this);
  TextTheme get textTheme => _theme.textTheme;
  TextStyle? get textStyleSmall => textTheme.labelSmall;
  TextStyle? get textStyleMedium => textTheme.labelMedium;
  TextStyle? get textStyleLarge => textTheme.labelLarge;
  TextStyle? get titleStyleSmall => textTheme.titleSmall;
  TextStyle? get titleStyleMedium => textTheme.titleMedium;
  TextStyle? get titleStyleLarge => textTheme.titleLarge;
  ColorScheme get colorScheme => _theme.colorScheme;
  Size get sizeDevice => MediaQuery.sizeOf(this);
}
