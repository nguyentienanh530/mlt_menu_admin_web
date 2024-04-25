part of '../widgets/list_food_is_show.dart';

extension on ListFoodIsShowViewState {
  Widget get _mobile {
    return Builder(builder: (context) {
      var foodIsShow = context.watch<FoodBloc>().state;
      return (switch (foodIsShow.status) {
        Status.loading => const LoadingScreen(),
        Status.empty => const EmptyScreen(),
        Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
        Status.success => Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearch()),
            const SizedBox(height: 16),
            Expanded(
                child: CommonRefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      _getData();
                    },
                    child: _buildWidget(foodIsShow.datas ?? <Food>[])))
          ])
      });
    });
  }
}
