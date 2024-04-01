import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/config/router.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_admin_web/features/food/data/model/food_model.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widget/display_white_text.dart';
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
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      top: defaultPadding),
                  child: const DailyRevenue()),
              _buildHeader(context),
              _buildTitle(context),
              Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: const _ListTable())
            ])));
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(defaultPadding / 2),
        margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: DisplayWhiteText(
                text: 'Danh sách bàn ăn',
                size: 14,
                fontWeight: FontWeight.bold)));
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height * 0.2,
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildUserAccount()),
                  SizedBox(width: defaultPadding / 2),
                  Expanded(child: _buildFoods()),
                  SizedBox(width: defaultPadding / 2),
                  Expanded(child: _buildTableNumber())
                ])));
  }

  Widget _buildUserAccount() {
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) => UserBloc()..add(UsersFetched()),
        child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => loadingOrInitState,
                  Status.empty => Text('Empty', style: context.textStyleSmall),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => _buidItemDashBoard(context,
                      title: "Người dùng",
                      title2: "Tài khoản",
                      value: state.datas!.length,
                      onTap: () {})
                }));
  }

  Widget _buildFoods() {
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsFetched(isShowFood: true)),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => loadingOrInitState,
            Status.empty => loadingOrInitState,
            Status.failure => Center(child: Text(state.error!)),
            Status.success => _buidItemDashBoard(context,
                  title: "Số lượng món",
                  title2: "Món",
                  value: state.datas!.length, onTap: () {
                // context.push(RouteName.searchFood);
              })
          });
        }));
  }

  Widget _buildTableNumber() {
    var tableState = context.watch<TableBloc>().state;
    return (switch (tableState.status) {
      Status.loading => Center(
          child: SpinKitCircle(color: context.colorScheme.primary, size: 30)),
      Status.failure => Center(child: Text(tableState.error ?? '')),
      Status.success => _buidItemDashBoard(context,
          title: "Tổng bàn",
          title2: "Tất cả",
          value: tableState.datas == null ? 0 : tableState.datas!.length,
          onTap: () {}),
      Status.empty => _buidItemDashBoard(context,
          title: "Tổng đơn", title2: "Đang chờ", value: 0, onTap: () {})
    });
  }

  Widget _buidItemDashBoard(BuildContext context,
      {String? title, String? title2, Function()? onTap, int? value}) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            elevation: 10,
            child: Container(
                padding: EdgeInsets.all(defaultPadding / 2),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(child: Text(title!)),
                      FittedBox(
                          child: Text(
                              value == null || value == 0
                                  ? "0"
                                  : value.toString(),
                              style: context.textTheme.titleLarge!.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)),
                      FittedBox(
                          child: Text(title2!,
                              style: context.textStyleSmall!.copyWith(
                                  color: Colors.white.withOpacity(0.5))))
                    ]
                        .animate(interval: 50.ms)
                        .slideX(
                            begin: -0.1,
                            end: 0,
                            curve: Curves.easeInOutCubic,
                            duration: 500.ms)
                        .fadeIn(
                            curve: Curves.easeInOutCubic, duration: 500.ms)))));
  }

  @override
  bool get wantKeepAlive => true;
}

class DailyRevenue extends StatelessWidget {
  const DailyRevenue({super.key});

  @override
  Widget build(BuildContext context) {
    var newOrder = context.watch<OrderBloc>().state;
    var tableState = context.watch<TableBloc>().state.datas;
    var dailyRevenue = context.watch<DailyRevenueCubit>().state;
    // final dataChartRevenue = context.watch<DataChartRevenueCubit>().state;
    var tableIsUseNumber = 0;

    for (var element in tableState ?? <TableModel>[]) {
      if (element.isUse) {
        tableIsUseNumber++;
      }
    }

    price() => Text(Ultils.currencyFormat(dailyRevenue),
        style: context.titleStyleMedium!.copyWith(
            fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
    title() =>
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Doanh thu ngày'.toUpperCase()),
        ]);

    status() =>
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          switch (newOrder.status) {
            Status.loading => const SizedBox(),
            Status.empty => childStatus(context, 'Đơn hàng mới', '0'),
            Status.failure =>
              Text(newOrder.error ?? '', style: context.textStyleSmall),
            Status.success => childStatus(
                context, 'Đơn hàng mới', newOrder.datas!.length.toString())
          },
          _buildOrderOnDay(context),
          childStatus(context, 'Bàn sử dụng', tableIsUseNumber.toString())
        ]);

    return Card(
        elevation: 10,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: context.sizeDevice.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      const SizedBox(height: 8),
                      price(),
                      SizedBox(
                          height: context.sizeDevice.height * 0.2,
                          child: const ChartRevenue()),
                      Divider(color: context.colorScheme.primary),
                      status()
                    ]))));
  }

  Widget childStatus(BuildContext context, String title, String value) =>
      Column(children: [
        Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
      ]);

  Widget _buildOrderOnDay(BuildContext context) {
    return BlocProvider(
        create: (context) => OrderBloc()..add(OrdersOnDayFecthed()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) {
          switch (state.status) {
            case Status.loading:
              return const LoadingScreen();
            case Status.empty:
              return const EmptyWidget();
            case Status.failure:
              return const Text('error');
            case Status.success:
              var ordersNumber = 0;
              var totalPrice = 0.0;
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
              }
              context
                  .read<DataChartRevenueCubit>()
                  .onDataChartRevenueChanged(listDataChart);

              context
                  .read<DailyRevenueCubit>()
                  .onDailyRevenueChanged(totalPrice);

              return childStatus(
                  context, 'Tổng đơn/Ngày', ordersNumber.toString());
            default:
              return const LoadingScreen();
          }
        }));
  }
}

class ItemCirclePercent extends StatelessWidget {
  const ItemCirclePercent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: SizedBox(height: context.sizeDevice.height * 0.2));
  }
}

class _ListTable extends StatelessWidget {
  const _ListTable();

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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newTables.length,
            itemBuilder: (context, index) =>
                _ItemTable(table: newTables[index]));
    }
  }
}

class _ItemTable extends StatelessWidget {
  const _ItemTable({required this.table});
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.push(RouteName.orderOnTable, extra: table),
        child: Card(
            elevation: 10,
            color: table.isUse ? Colors.green.shade900.withOpacity(0.3) : null,
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(3),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FittedBox(
                          child: Text('Bàn', style: context.textStyleSmall)),
                      FittedBox(
                          child: Text(table.name,
                              style: context.titleStyleMedium!.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.bold))),
                      FittedBox(
                          child: Text(Ultils.tableStatus(table.isUse),
                              style: context.textStyleSmall!.copyWith(
                                  color: table.isUse
                                      ? null
                                      : context.colorScheme.errorContainer)))
                    ]))));
  }
}
