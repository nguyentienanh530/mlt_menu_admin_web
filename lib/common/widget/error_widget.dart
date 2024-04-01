import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  const ErrorWidgetCustom({super.key, required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            margin: const EdgeInsets.all(16),
            color: context.colorScheme.error.withOpacity(0.2),
            child: Container(
                height: context.sizeDevice.width / 2,
                width: context.sizeDevice.width / 2,
                padding: const EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outlined,
                          color: context.colorScheme.error, size: 50.0),
                      const SizedBox(height: 10.0),
                      Text('Error Occurred!',
                          style: context.titleStyleLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      Text(errorMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: context.textStyleSmall)
                    ]))));
  }
}
