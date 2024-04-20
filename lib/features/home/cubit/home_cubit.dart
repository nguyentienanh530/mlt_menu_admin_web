import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/screen/dashboard_screen.dart';

class PageHomeCubit extends Cubit<Widget> {
  PageHomeCubit() : super(DashboardScreen());

  void pageChanged(Widget widget) => emit(widget);
}
