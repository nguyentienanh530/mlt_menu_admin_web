part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get dailyRevenue {
    var dailyRevenue = context.watch<DailyRevenueCubit>().state;
    // final dataChartRevenue = context.watch<DataChartRevenueCubit>().state;

    price() => Text(Ultils.currencyFormat(dailyRevenue),
        style: context.titleStyleMedium!.copyWith(
            fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
    title() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Doanh thu ngày'.toUpperCase())]);

    return Card(
        elevation: 10,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(),
                  const SizedBox(height: 8),
                  price(),
                  const Expanded(
                    child: SizedBox(
                        // height: context.sizeDevice.height * 0.3,
                        child: ChartRevenue()),
                  )
                ])));
  }
}
