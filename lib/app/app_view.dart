import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Minh Long Menu',
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        // routerDelegate: router.routerDelegate,
        // routeInformationParser: router.routeInformationParser,
        // routeInformationProvider: router.routeInformationProvider,
        routerConfig: router);
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
