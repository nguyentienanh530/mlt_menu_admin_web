part of '../widgets/list_food_is_show.dart';

extension on ListFoodIsShowViewState {
  Widget get _web {
    // _key.currentState!.closeDrawer();
    return CommonRefreshIndicator(onRefresh: () async {
      await Future.delayed(const Duration(milliseconds: 500));
      _getData();
    }, child: Builder(builder: (context) {
      var foodIsShow = context.watch<FoodBloc>().state;
      return (switch (foodIsShow.status) {
        Status.loading => const LoadingScreen(),
        Status.empty => const EmptyScreen(),
        Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
        Status.success => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                const Spacer(flex: 2),
                Expanded(child: _buildSearch())
              ]),
              const SizedBox(height: 8),
              Expanded(child: _buildWidget(foodIsShow.datas ?? <Food>[]))
            ]))
      });
    }));
  }
}
