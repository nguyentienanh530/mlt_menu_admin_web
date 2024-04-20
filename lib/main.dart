import 'package:mlt_menu_admin_web/firebase_options.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  runApp(
      // DevicePreview(
      // enabled: !kReleaseMode,
      // builder: (context) =>
      MainApp(authenticationRepository: authenticationRepository

          // )
          ));
}
