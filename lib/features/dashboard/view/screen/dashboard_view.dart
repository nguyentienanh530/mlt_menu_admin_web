import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
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
      _buildInfo(context, tableIsUseNumber),
      const SizedBox(height: 16),
      _buildTable(),
      const SizedBox(height: 16),
      _buildTitle(title: 'Món đặt nhiều'),
      const SizedBox(height: 16),
      const FoodBestSeller(),
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
                  value: tableIsUseNumber.toString()),
              _buildUserAccount(),
              _buildFoods(),
              _buildTableNumber()
            ])),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DailyRevenue(),
                    const SizedBox(height: 16),
                    // _buildTitle1(
                    //   title: 'Danh mục',
                    //   onPressed: () {},
                    // ),
                    // const SizedBox(height: 16),
                    // SizedBox(
                    //     height: context.sizeDevice.height * 0.15,
                    //     child: const CategoryView()),
                    // const SizedBox(height: 16),
                    _buildTitle(title: 'Món đặt nhiều'),
                    const SizedBox(height: 16),
                    const FoodBestSeller(),
                    const SizedBox(height: 16),
                  ])),
          Expanded(child: _buildTable())
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            SizedBox(
                height: 50,
                child: Center(child: _buildTitle(title: 'Danh sách bàn ăn'))),
            Divider(color: context.colorScheme.primary, height: 0.1),
            Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: const _ListTable(isScroll: true))
          ]));

  Widget _buildInfo(BuildContext context, int tableIsUseNumber) {
    return SizedBox(
        height: Responsive.isMobile(context)
            ? context.sizeDevice.height * 0.2
            : context.sizeDevice.height * 0.3,
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
              ])),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                _buildUserAccount(),
                SizedBox(width: defaultPadding / 2),
                _buildFoods(),
                SizedBox(width: defaultPadding / 2),
                _buildTableNumber()
              ]))
        ]));
  }

  Widget _buildUserAccount() {
    return BlocProvider(
        create: (context) => UserBloc()..add(UsersFetched()),
        child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => _buildLoadingItem(),
                  Status.empty => Text('Empty', style: context.textStyleSmall),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => _buildItem(
                      svg: 'assets/icon/user.svg',
                      title: "Người dùng",
                      value: state.datas!.length.toString(),
                    )
                }));
  }

  Widget _buildFoods() {
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsFetched(isShowFood: true)),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => _buildLoadingItem(),
            Status.empty => _buildItem(
                title: "Số lượng món", value: '0', svg: 'assets/icon/food.svg'),
            Status.failure => Center(child: Text(state.error!)),
            Status.success => _buildItem(
                title: "Số lượng món",
                value: state.datas!.length.toString(),
                svg: 'assets/icon/food.svg')
          });
        }));
  }

  Widget _buildTableNumber() {
    var tableState = context.watch<TableBloc>().state;
    return (switch (tableState.status) {
      Status.loading => _buildLoadingItem(),
      Status.failure => Center(child: Text(tableState.error ?? '')),
      Status.success => _buildItem(
          title: "Tổng bàn",
          value: tableState.datas == null
              ? '0'
              : tableState.datas!.length.toString(),
          svg: 'assets/icon/dinner_table.svg'),
      Status.empty => _buildItem(
          title: "Tổng đơn", value: '0', svg: 'assets/icon/dinner_table.svg')
    });
  }

  @override
  bool get wantKeepAlive => true;
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
    title() =>
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Doanh thu ngày'.toUpperCase()),
        ]);

    return Card(
        elevation: 10,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    ]))));
  }

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
                crossAxisCount: countGridView(context)),
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
      return 3;
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
    return GestureDetector(
        onTap: () {
          // context.push(RouteName.orderOnTable, extra: table)
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  content: SizedBox(
                      width: 600, child: OrderOnTable(tableModel: table))));
        },
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
