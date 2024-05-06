part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get mobile {
    var tableIsUseNumber = 0;
    var tableState = context.watch<TableBloc>().state.datas;
    for (var element in tableState ?? <TableModel>[]) {
      if (element.isUse) {
        tableIsUseNumber++;
      }
    }
    return Column(children: [
      SizedBox(
          width: double.infinity,
          height: context.sizeDevice.height * 0.3,
          child: dailyRevenue),
      const SizedBox(height: 16),
      SizedBox(height: context.sizeDevice.height * 0.3, child: performance),
      // performance,
      const SizedBox(height: 16),
      buildInfo(context, tableIsUseNumber),
      const SizedBox(height: 16),
      // SizedBox(height: context.sizeDevice.height * 0.35, child: _leftInfo),
      _leftInfo,
      const SizedBox(height: 16),
      listTable,
      const SizedBox(height: 16),
      _buildTitle(title: 'Món đặt nhiều'),
      const SizedBox(height: 16),
      const FoodBestSeller()
    ]);
  }
}
