import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';

class CommonRefreshIndicator extends StatelessWidget {
  const CommonRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        displacement: 10,
        color: context.colorScheme.secondary,
        backgroundColor: context.colorScheme.primaryContainer,
        // triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: onRefresh,
        child: child);
  }
}
