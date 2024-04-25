part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get orderOnDay {
    return BlocProvider(
        create: (context) => OrderBloc()..add(OrdersOnDayFecthed()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) {
          switch (state.status) {
            case Status.loading:
              return _buildLoadingItem();
            case Status.empty:
              return _buildItem(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Tổng đơn/ngày',
                  value: '0');
            case Status.failure:
              return _buildItem(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Tổng đơn/ngày',
                  value: state.error ?? '');
            case Status.success:
              var ordersNumber = 0;
              var ordersNumberYes = 0;
              var totalPrice = 0.0;
              var totalPriceYesterday = 0.0;
              final listCurentDataChart = <FlSpot>[];
              final listYesterdayDataChart = <FlSpot>[];

              final today = DateTime.now();
              final yesterday = today.subtract(const Duration(days: 1));

              for (var element in state.datas ?? <Orders>[]) {
                final orderDate = Ultils.formatToDate(element.payTime ?? '');
                if (orderDate == Ultils.formatToDate(today.toString())) {
                  ordersNumber++;
                  totalPrice += double.parse(element.totalPrice.toString());
                  listCurentDataChart.add(FlSpot(
                      double.parse(ordersNumber.toString()),
                      double.parse(
                          (element.totalPrice! / 1000000).toString())));
                } else if (orderDate ==
                    Ultils.formatToDate(yesterday.toString())) {
                  ordersNumberYes++;
                  totalPriceYesterday +=
                      double.parse(element.totalPrice.toString());
                  listYesterdayDataChart.add(FlSpot(
                      double.parse(ordersNumberYes.toString()),
                      double.parse(
                          (element.totalPrice! / 1000000).toString())));
                }
              }

              context
                  .read<DataChartRevenueCubit>()
                  .onDataChartRevenueChanged(listCurentDataChart);

              context
                  .read<DataChartYesterdayCubit>()
                  .onDataChartYesterdayChanged(listYesterdayDataChart);

              context
                  .read<TotalPriceYesterday>()
                  .onTotalPriceYesterdayChanged(totalPriceYesterday);

              context
                  .read<DailyRevenueCubit>()
                  .onDailyRevenueChanged(totalPrice);

              return _buildItem(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Tổng đơn/ngày',
                  value: ordersNumber.toString());
            default:
              return const LoadingScreen();
          }
        }));
  }
}
