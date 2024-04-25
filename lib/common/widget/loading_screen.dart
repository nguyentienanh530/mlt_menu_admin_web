import 'package:mlt_menu_admin/core/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitCircle(color: context.colorScheme.secondary, size: 30));
  }
}
