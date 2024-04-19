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
                  svg: 'assets/icon/ordered.svg',
                  title: 'Tổng đơn/ngày',
                  value: '0');
            case Status.failure:
              return _buildItem(
                  svg: 'assets/icon/ordered.svg',
                  title: 'Tổng đơn/ngày',
                  value: state.error ?? '');
            case Status.success:
              var ordersNumber = 0;
              var totalPrice = 0.0;
              var totalPriceYesterday = 0.0;
              final listDataChart = <FlSpot>[];

              final today = DateTime.now();
              final yesterday = today.subtract(const Duration(days: 1));

              for (var element in state.datas ?? <Orders>[]) {
                final orderDate = Ultils.formatToDate(element.payTime ?? '');
                if (orderDate == Ultils.formatToDate(today.toString())) {
                  ordersNumber++;
                  totalPrice += double.parse(element.totalPrice.toString());
                  listDataChart.add(FlSpot(
                      double.parse(ordersNumber.toString()),
                      double.parse(element.totalPrice.toString())));
                } else if (orderDate ==
                    Ultils.formatToDate(yesterday.toString())) {
                  totalPriceYesterday +=
                      double.parse(element.totalPrice.toString());
                }
              }

              context
                  .read<DataChartRevenueCubit>()
                  .onDataChartRevenueChanged(listDataChart);

              context
                  .read<TotalPriceYesterday>()
                  .onTotalPriceYesterdayChanged(totalPriceYesterday);

              context
                  .read<DailyRevenueCubit>()
                  .onDailyRevenueChanged(totalPrice);

              return _buildItem(
                  svg: 'assets/icon/ordered.svg',
                  title: 'Tổng đơn/ngày',
                  value: ordersNumber.toString());
            default:
              return const LoadingScreen();
          }
        }));
  }
}
