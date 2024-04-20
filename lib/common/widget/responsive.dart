import 'package:flutter/material.dart';
import 'package:mlt_menu_admin_web/core/utils/extensions.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) => context.sizeDevice.width < 850;

  static bool isTablet(BuildContext context) =>
      context.sizeDevice.width < 1100 && context.sizeDevice.width >= 850;

  static bool isDesktop(BuildContext context) =>
      context.sizeDevice.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = context.sizeDevice;
    if (size.width >= 1100) {
      return desktop;
    }
    if (size.width >= 850 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
