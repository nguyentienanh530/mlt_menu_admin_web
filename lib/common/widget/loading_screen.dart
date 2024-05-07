import 'package:lottie/lottie.dart';
// import 'package:mlt_menu_admin/core/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //     child: SpinKitCircle(color: context.colorScheme.secondary, size: 30));

    return Center(
        child: SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset('assets/animations/loading.json')));
  }
}
