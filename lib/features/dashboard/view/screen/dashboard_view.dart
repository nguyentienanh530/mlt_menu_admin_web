import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/total_price_yesterday_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/widgets/best_seller_view.dart';
import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_admin_web/features/food/data/model/food_model.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_on_table.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../common/widget/empty_widget.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/chart_revenua.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (!mounted) return;
    context.read<OrderBloc>().add(NewOrdersFecthed());
    context.read<TableBloc>().add(TablesOnStreamFetched());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          getData();
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Responsive(
                mobile: _buildMobileWidget(),
                tablet: _buildMobileWidget(),
                desktop: _buildWebWidget())));
  }

  Widget _buildMobileWidget() {
    var tableIsUseNumber = 0;
    var tableState = context.watch<TableBloc>().state.datas;
    for (var element in tableState ?? <TableModel>[]) {
      if (element.isUse) {
        tableIsUseNumber++;
      }
    }
    return Column(children: [
      const DailyRevenue(),
      const SizedBox(height: 16),
      SizedBox(
          height: context.sizeDevice.height * 0.3, child: const Performance()),
      const SizedBox(height: 16),
      _buildInfo(context, tableIsUseNumber),
      const SizedBox(height: 16),
      _buildOrderInfo(),
      const SizedBox(height: 16),
      _buildTable(),
      const SizedBox(height: 16),
      _buildTitle(title: 'Món đặt nhiều'),
      const SizedBox(height: 16),
      const FoodBestSeller()
    ]);
  }

  Widget _buildItem(
      {required String svg, required String title, required String value}) {
    return Expanded(
        child: Card(
            elevation: 10,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(svg,
                                colorFilter: ColorFilter.mode(
                                    context.colorScheme.secondary,
                                    BlendMode.srcIn)),
                            const SizedBox(height: 8),
                            Text(title,
                                style: context.textStyleSmall!.copyWith(
                                    color: Colors.white.withOpacity(0.5)))
                          ]),
                      Text(value,
                          style: context.titleStyleMedium!
                              .copyWith(fontWeight: FontWeight.bold))
                    ]))));
  }

  Widget _buildWebWidget() {
    return Builder(builder: (context) {
      var tableState = context.watch<TableBloc>().state.datas;
      var tableIsUseNumber = 0;

      for (var element in tableState ?? <TableModel>[]) {
        if (element.isUse) {
          tableIsUseNumber++;
        }
      }
      return Column(children: [
        SizedBox(
            height: 100,
            child: Row(children: [
              _buildNewOrder(),
              _buildOrderOnDay(),
              _buildItem(
                  svg: 'assets/icon/dinner_table.svg',
                  title: 'Bàn sử dụng',
                  value: tableIsUseNumber.toString())
            ])),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: context.sizeDevice.height * 0.3,
                      child: const Row(children: [
                        Expanded(child: DailyRevenue()),
                        Expanded(child: Performance())
                      ]),
                    ),
                    const SizedBox(height: 16),
                    _buildTable(),
                    const SizedBox(height: 16)
                  ])),
          const SizedBox(width: 16),
          Expanded(
              child: Column(children: [
            _buildOrderInfo(),
            const SizedBox(height: 16),
            _buildTitle(title: 'Món đặt nhiều'),
            const SizedBox(height: 16),
            const FoodBestSeller(),
            const SizedBox(height: 16)
          ]))
        ])
      ]);
    });
  }

  Widget _buildTitle({required String title}) {
    return Text(title,
        style: context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildLoadingItem() => const Expanded(child: LoadingScreen());

  Widget _buildNewOrder() {
    var newOrder = context.watch<OrderBloc>().state;
    return switch (newOrder.status) {
      Status.loading => _buildLoadingItem(),
      Status.empty => _buildItem(
          svg: 'assets/icon/cart.svg', title: 'Đơn hàng mới', value: '0'),
      Status.failure =>
        Text(newOrder.error ?? '', style: context.textStyleSmall),
      Status.success => _buildItem(
          svg: 'assets/icon/cart.svg',
          title: 'Đơn hàng mới',
          value: newOrder.datas!.length.toString())
    };
  }

  Widget _buildOrderOnDay() {
    return BlocProvider(
        create: (context) => OrderBloc()..add(OrdersOnDayFecthed()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) {
          switch (state.status) {
            case Status.loading:
              return _buildLoadingItem();
            case Status.empty:
              return const EmptyWidget();
            case Status.failure:
              return const Text('error');
            case Status.success:
              var ordersNumber = 0;
              var totalPrice = 0.0;
              var totalPriceYesterday = 0.0;
              final listDataChart = <FlSpot>[];
              // var index =0;
              for (var element in state.datas ?? <Orders>[]) {
                if (Ultils.formatToDate(
                        element.payTime ?? DateTime.now().day.toString()) ==
                    Ultils.formatToDate(DateTime.now().toString())) {
                  ordersNumber++;
                  totalPrice += double.parse(element.totalPrice.toString());
                  listDataChart.add(FlSpot(
                      double.parse(ordersNumber.toString()),
                      double.parse(element.totalPrice.toString())));
                }
                var date = Ultils.formatToDate(DateTime.now().toString())
                    .compareTo(Ultils.formatToDate(
                        element.payTime ?? DateTime.now().day.toString()));

                if (date == -1) {
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

  Widget _buildTable() => Card(
      elevation: 10,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 50,
                child: Center(child: _buildTitle(title: 'Danh sách bàn ăn'))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: const _ListTable(isScroll: true)),
            SizedBox(height: defaultPadding)
          ]));

  Widget _buildInfo(BuildContext context, int tableIsUseNumber) {
    return SizedBox(
        height: Responsive.isMobile(context)
            ? context.sizeDevice.height * 0.1
            : context.sizeDevice.height * 0.15,
        child: Column(children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                _buildNewOrder(),
                SizedBox(width: defaultPadding / 2),
                _buildOrderOnDay(),
                SizedBox(width: defaultPadding / 2),
                _buildItem(
                    svg: 'assets/icon/dinner_table.svg',
                    title: 'Bàn sử dụng',
                    value: tableIsUseNumber.toString())
              ]))
        ]));
  }

  Widget _buildUserAccount() {
    return BlocProvider(
        create: (context) => UserBloc()..add(UsersFetched()),
        child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.empty => Text('Empty', style: context.textStyleSmall),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => _buildItemChildOrderInfo(
                      svgPath: 'assets/icon/user.svg',
                      title: 'Tổng người dùng',
                      value: state.datas!.length.toString())
                }));
  }

  Widget _buildFoods() {
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsFetched(isShowFood: true)),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => _buildItem(
                title: "Số lượng món", value: '0', svg: 'assets/icon/food.svg'),
            Status.failure => Center(child: Text(state.error!)),
            Status.success => _buildItemChildOrderInfo(
                svgPath: 'assets/icon/food.svg',
                title: 'Số lượng món ăn',
                value: state.datas!.length.toString())
          });
        }));
  }

  Widget _buildTableNumber() {
    var tableState = context.watch<TableBloc>().state;
    return (switch (tableState.status) {
      Status.loading => const LoadingScreen(),
      Status.failure => Center(child: Text(tableState.error ?? '')),
      Status.success => _buildItemChildOrderInfo(
          svgPath: 'assets/icon/dinner_table.svg',
          title: 'Số lượng bàn ăn',
          value: tableState.datas!.length.toString()),
      Status.empty => _buildItemChildOrderInfo(
          svgPath: 'assets/icon/dinner_table.svg',
          title: 'Số lượng bàn ăn',
          value: '0')
    });
  }

  Widget _buildOrderHistory() {
    return BlocProvider(
        create: (context) => OrderBloc()..add(OrdersHistoryFecthed()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.empty => Text('Empty', style: context.textStyleSmall),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => _buildItemChildOrderInfo(
                      svgPath: 'assets/icon/ordered.svg',
                      title: 'Tổng đơn hoàn thành',
                      value: state.datas!.length.toString())
                }));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildOrderInfo() => Card(
      elevation: 10,
      child: Container(
          margin: const EdgeInsets.all(16),
          // height: context.sizeDevice.height * 0.3,
          width: double.infinity,
          child: Column(children: [
            _buildOrderHistory(),
            const SizedBox(height: 16),
            _buildUserAccount(),
            const SizedBox(height: 16),
            _buildFoods(),
            const SizedBox(height: 16),
            _buildTableNumber(),
          ])));

  Widget _buildItemChildOrderInfo(
          {String? svgPath, String? title, String? value}) =>
      SizedBox(
          height: 50,
          child: Row(children: [
            Container(
                // margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: context.colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: context.colorScheme.secondary.withOpacity(0.8))),
                child: SvgPicture.asset(svgPath ?? 'assets/icon/cart.svg',
                    colorFilter: ColorFilter.mode(
                        context.colorScheme.secondary, BlendMode.srcIn))),
            const SizedBox(width: 16),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(title ?? '',
                      style: context.textStyleMedium!
                          .copyWith(color: Colors.white.withOpacity(0.3))),
                  Text(value ?? '',
                      style: context.titleStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold))
                ])
          ]));
}

class DailyRevenue extends StatelessWidget {
  const DailyRevenue({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                      height: context.sizeDevice.height * 0.2,
                      child: const ChartRevenue())
                ])));
  }

  Widget childStatus(BuildContext context, String title, String value) =>
      Column(children: [
        Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
      ]);
}

class Performance extends StatelessWidget {
  const Performance({super.key});

  @override
  Widget build(BuildContext context) {
    var dailyRevenue = context.watch<DailyRevenueCubit>().state;
    var totalPriceYesterday = context.watch<TotalPriceYesterday>().state;
    var percentInCome = 0;
    if (totalPriceYesterday != 0) {
      var percent = (dailyRevenue / totalPriceYesterday) * 100;
      var parseToDouble = double.parse((percent - 100).toString());
      percentInCome = parseToDouble.truncate();
      logger.d('percent: $percentInCome');
    } else {
      logger.d(
          'Tổng doanh thu của ngày trước đó là 0, không thể tính phần trăm.');
      // Xử lý trường hợp tổng doanh thu của ngày trước đó bằng 0 ở đây
    }

    price() => Text(Ultils.currencyFormat(totalPriceYesterday),
        style: context.titleStyleMedium!.copyWith(
            fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
    title() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Hiệu suất'.toUpperCase())]);

    return Card(
        elevation: 10,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                height: context.sizeDevice.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      const SizedBox(height: 8),
                      // price(),
                      SizedBox(
                          height: context.sizeDevice.height * 0.2,
                          child: Row(children: [
                            Expanded(
                                child: _buildCircularPercentIndicator(
                                    context, percentInCome)),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  const Text('Doanh thu hôm qua'),
                                  const SizedBox(height: 8),
                                  price()
                                ]))
                          ]))
                    ]))));
  }

  double _handlePercent(int percentInCome) {
    if ((percentInCome / 100) < 0) {
      return 0.0;
    } else if ((percentInCome / 100) > 1) {
      return 1.0;
    } else {
      return (percentInCome / 100);
    }
  }

  Widget _buildCircularPercentIndicator(
          BuildContext context, int percentInCome) =>
      FittedBox(
        child: CircularPercentIndicator(
            radius: context.sizeDevice.height * 0.07,
            lineWidth: 13.0,
            animation: true,
            percent: _handlePercent(percentInCome),
            center: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              percentInCome < 0
                  ? const Icon(Icons.arrow_circle_down_rounded,
                      color: Colors.red)
                  : const Icon(Icons.arrow_circle_up_rounded,
                      color: Colors.green),
              const SizedBox(width: 8),
              Text('$percentInCome%',
                  style: context.titleStyleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: percentInCome < 0 ? Colors.red : Colors.green))
            ]),
            footer: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Doanh thu so với hôm qua",
                    style: context.titleStyleMedium)),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.green),
      );

  Widget childStatus(BuildContext context, String title, String value) =>
      Column(children: [
        Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
      ]);
}

class ItemCirclePercent extends StatelessWidget {
  const ItemCirclePercent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: SizedBox(height: context.sizeDevice.height * 0.2));
  }
}

class _ListTable extends StatelessWidget {
  const _ListTable({required this.isScroll});
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    var tableState = context.watch<TableBloc>().state;
    switch (tableState.status) {
      case Status.empty:
        return const EmptyWidget();
      case Status.loading:
        return const LoadingScreen();
      case Status.failure:
        return ErrorWidgetCustom(errorMessage: tableState.error ?? '');
      case Status.success:
        var newTables = [...tableState.datas ?? <TableModel>[]];
        newTables.sort((a, b) => a.name.compareTo(b.name));
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: context.sizeDevice.height * 0.1),
            physics: isScroll
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newTables.length,
            itemBuilder: (context, index) =>
                _ItemTable(table: newTables[index]));
    }
  }

  int countGridView(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return 6;
    } else if (Responsive.isTablet(context)) {
      return 6;
    } else {
      return 4;
    }
  }
}

class _ItemTable extends StatelessWidget {
  const _ItemTable({required this.table});
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // context.push(RouteName.orderOnTable, extra: table)
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  content: SizedBox(
                      width: 600, child: OrderOnTable(tableModel: table))));
        },
        child: Card(

            // color: table.isUse ? Colors.green.shade900.withOpacity(0.3) : null,
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: 'Bàn: ',
                                    style: context.textStyleSmall!.copyWith(
                                        color: Colors.white.withOpacity(0.3)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: table.name,
                                          style: context.titleStyleMedium!
                                              .copyWith(
                                                  color: context
                                                      .colorScheme.secondary,
                                                  fontWeight: FontWeight.bold))
                                    ])),
                            RichText(
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: 'Số ghế: ',
                                    style: context.textStyleSmall!.copyWith(
                                        color: Colors.white.withOpacity(0.3)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: table.seats.toString(),
                                          style: context.textStyleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold))
                                    ])),
                            RichText(
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: 'trạng thái: ',
                                    style: context.textStyleSmall!.copyWith(
                                        color: Colors.white.withOpacity(0.3)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: Ultils.tableStatus(table.isUse),
                                          style: context.textStyleSmall!
                                              .copyWith(
                                                  color: table.isUse
                                                      ? Colors.green
                                                      : context.colorScheme
                                                          .errorContainer,
                                                  fontWeight: FontWeight.bold))
                                    ]))
                          ])),
                  Expanded(
                      child: Center(
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: table.isUse
                                          ? Colors.green
                                          : Colors.red),
                                  shape: BoxShape.circle),
                              child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: table.isUse
                                          ? Colors.green
                                          : Colors.red)))))
                ]))));
  }
}
