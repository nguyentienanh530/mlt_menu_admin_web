part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get dailyRevenue {
    // final dataChartRevenue = context.watch<DataChartRevenueCubit>().state;

    return Builder(builder: (context) {
      var dailyRevenue = context.watch<DailyRevenueCubit>().state;
      price() => FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(Ultils.currencyFormat(dailyRevenue),
                style: context.titleStyleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.secondary)),
          );
      title() => FittedBox(
          fit: BoxFit.scaleDown, child: Text('Doanh thu ngày'.toUpperCase()));
      return Card(
          elevation: 10,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          title(),
                          const SizedBox(height: 8),
                          price()
                        ])),
                    const SizedBox(height: 8),
                    const Expanded(flex: 3, child: ChartRevenue())
                  ])));
    });
  }
}
