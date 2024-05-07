part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get dailyRevenue {
    // final dataChartRevenue = context.watch<DataChartRevenueCubit>().state;

    return Builder(builder: (context) {
      var dailyRevenue = context.watch<DailyRevenueCubit>().state;

      return Card(
          elevation: 10,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(dailyRevenue),
                const SizedBox(height: 8),
                const Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(16.0), child: ChartRevenue()))
              ]));
    });
  }

  price(double dailyRevenue) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(Ultils.currencyFormat(dailyRevenue),
            style: context.titleStyleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.secondary)),
      );

  title() => FittedBox(
      fit: BoxFit.scaleDown, child: Text('Doanh thu ngày'.toUpperCase()));

  Widget _buildHeader(double dailyRevenue) => Container(
      height: 40,
      color: context.colorScheme.primary.withOpacity(0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [title(), price(dailyRevenue)])));
}
