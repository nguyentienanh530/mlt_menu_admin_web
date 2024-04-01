// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    log('onEvent: $bloc --> $event');
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError: $bloc --> $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    log('onChange: $bloc --> $change');
    super.onChange(bloc, change);
  }

  // @override
  // void onTransition(
  //     Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
  //   log('onTransition: $bloc --> $transition');
  //   super.onTransition(bloc, transition);
  // }

  @override
  void onCreate(BlocBase bloc) {
    log('onCreate: $bloc');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    log('onClose: $bloc');
    super.onClose(bloc);
  }
}
