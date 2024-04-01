import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';

import '../widget/spinkit_indicator.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.descriptrion,
    required this.isProgressed,
    this.onPressed,
  });

  final String descriptrion;
  final bool isProgressed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // backgroundColor: context.colorScheme.surface,
        // title: isProgressed
        //     ? Text("Please wait...", style: context.textStyleLarge)
        //     : Center(
        //         child: Text("Thành công!", style: context.titleStyleLarge)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 15),
      isProgressed
          ? const SpinKitIndicator(type: SpinKitType.circle)
          : const SizedBox(),
      const SizedBox(height: 15),
      Text(descriptrion),
      const SizedBox(height: 15),
      SizedBox(
          width: double.infinity,
          child: isProgressed
              ? const SizedBox()
              : ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          context.colorScheme.secondary)),
                  onPressed: onPressed,
                  child: Text("Xác nhận",
                      style: context.textStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold))))
    ]));
  }
}
