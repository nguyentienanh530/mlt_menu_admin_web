import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';

import '../../../food/data/model/food_model.dart';

class FoodBestSeller extends StatelessWidget {
  const FoodBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsPopulerFetched(isShowFood: true)),
        child: Builder(builder: (context) {
          var state = context.watch<FoodBloc>().state;
          return switch (state.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const EmptyWidget(),
            Status.failure =>
              ErrorWidgetCustom(errorMessage: state.error ?? ''),
            Status.success =>
              _buildSuccessWidget(context, state.datas ?? <Food>[])
          };
        }));
  }

  Widget _buildFoods(BuildContext context, Food food) {
    return Card(
        elevation: 10,
        child: Column(children: [
          Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.network(food.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress != null
                            ? const LoadingScreen()
                            : child),
              )),
          const SizedBox(height: 8),
          Expanded(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(food.name, textAlign: TextAlign.center),
                  ))),
          Expanded(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Lần đặt: ${food.count.toString()}',
                      textAlign: TextAlign.center)))
        ]));
  }

  _buildSuccessWidget(BuildContext context, List<Food> foods) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _countGrid(context)),
        itemCount: foods.length >= 12 ? 12 : foods.length,
        itemBuilder: (context, index) => _buildFoods(context, foods[index]));
  }

  int _countGrid(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return 2;
    } else if (Responsive.isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }
}
