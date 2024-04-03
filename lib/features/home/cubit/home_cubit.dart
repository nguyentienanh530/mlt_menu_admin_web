import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:mlt_menu_admin_web/features/food/view/widgets/list_food_is_show.dart';

class PageHomeCubit extends Cubit<Widget> {
  PageHomeCubit() : super(const ListFoodIsShow(isShowFood: true));
  void pageChanged(Widget widget) => emit(widget);
}
