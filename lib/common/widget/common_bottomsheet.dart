import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CommonBottomSheet extends StatelessWidget {
  final String? title;
  final String? textConfirm;
  final String? textCancel;
  final Color? textCancelColor;
  final Color? textConfirmColor;
  final Function() onConfirm;

  const CommonBottomSheet({
    super.key,
    this.title,
    this.textConfirm,
    this.textCancel,
    required this.onConfirm,
    this.textCancelColor,
    this.textConfirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
        title: Text(title ?? ''),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => context.pop(),
          isDestructiveAction: true,
          child: Text(textCancel ?? ''),
        ),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: onConfirm,
              child: Text(textConfirm ?? ''))
        ]);
  }
}
