import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum SpinKitType { wave, circle }

class SpinKitIndicator extends StatelessWidget {
  const SpinKitIndicator({
    super.key,
    this.type = SpinKitType.wave,
  });

  final SpinKitType type;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (type) {
      case SpinKitType.wave:
        widget = SpinKitWave(
          color: context.colorScheme.secondary,
          size: 30.0,
        );
        break;
      case SpinKitType.circle:
        widget = SpinKitFadingCircle(
          color: context.colorScheme.secondary,
          size: 30.0,
        );
    }
    return Center(child: widget);
  }
}
