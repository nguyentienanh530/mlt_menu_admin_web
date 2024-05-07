import 'package:flutter/material.dart';

// import 'widgets.dart';

class CommonLineText extends StatelessWidget {
  final String? title, value;
  // final Color? color;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  final bool? isDarkText;
  const CommonLineText(
      {super.key,
      this.title,
      this.value,
      // this.color,
      this.titleStyle,
      this.isDarkText = false,
      this.valueStyle});
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: title ?? "",
                style: titleStyle ?? const TextStyle(color: Colors.white60),
                children: <TextSpan>[
                  TextSpan(
                      text: value ?? '',
                      style: valueStyle ?? const TextStyle(color: Colors.white))
                ])));
  }
}
