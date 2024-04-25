import 'package:flutter/foundation.dart';
import 'package:mlt_menu_admin/firebase_options.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  if (kIsWeb) {
    setPathUrlStrategy();
  }

  // runZoned(
  //   () {
  //     WidgetsFlutterBinding.ensureInitialized(); // Initialize bindings
  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) =>
      MainApp(authenticationRepository: authenticationRepository));

  //   },
  //   zoneSpecification: const ZoneSpecification(
  //       // Any zone-specific overrides can be defined here
  //       ),
  //   // Other zone-specific properties can be set here
  // );
}
