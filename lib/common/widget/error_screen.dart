import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorMsg;
  const ErrorScreen({super.key, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 4,
              child: Container(
                  margin: EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                      color: Colors.black38, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(27),
                  child: Image.asset("assets/image/error.png", width: 214))),
          Expanded(
              child: Center(
                  child: Text(AppString.errorTitle,
                      style: context.titleStyleLarge))),
          Expanded(
              child: Center(
                  child: Text(errorMsg!,
                      style: context.textStyleSmall,
                      textAlign: TextAlign.center)))
        ]);
  }
}
