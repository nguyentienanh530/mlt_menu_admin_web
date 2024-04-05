import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/screen/dashboard_screen.dart';

import '../../order/view/screen/order_current_screen.dart';

class PageHomeCubit extends Cubit<Widget> {
  // PageHomeCubit() : super(const DashboardScreen());
  PageHomeCubit() : super(const CurrentOrder());

  void pageChanged(Widget widget) => emit(widget);
}
