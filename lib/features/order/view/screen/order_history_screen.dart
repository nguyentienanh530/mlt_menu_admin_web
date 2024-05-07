import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/widget/responsive.dart';
import 'package:mlt_menu_admin/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/features/order/data/model/order_group.dart';
import '../../data/model/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => OrderBloc(),
        child: Scaffold(
            key: _key,
            appBar: AppBar(
                title: Text('Lịch sử đơn',
                    style: context.titleStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                centerTitle: true,
                automaticallyImplyLeading:
                    Responsive.isDesktop(context) ? false : true),
            body: const OrderHistoryView()));
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (!context.mounted) return;
    context.read<OrderBloc>().add(OrdersHistoryFecthed());
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var orderState = context.watch<OrderBloc>().state;
      return (switch (orderState.status) {
        Status.loading => const LoadingScreen(),
        Status.empty => const EmptyScreen(),
        Status.failure => ErrorScreen(errorMsg: orderState.error),
        Status.success => Responsive(
            mobile: _buildMobile(orderState.datas as List<Orders>),
            tablet: _buildMobile(orderState.datas as List<Orders>),
            desktop: _buildWeb(orderState.datas as List<Orders>))
      });
    });
  }

  Widget _buildWeb(List<Orders> orders) {
    return Row(children: [
      Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildBody(orders),
          ))
    ]);
  }

  Widget _buildMobile(List<Orders> orders) {
    return _buildBody(orders);
  }

  Widget _buildBody(List<Orders> orders) {
    final groupedOrders = groupOrdersByPayTime(orders);
    groupedOrders.sort((a, b) => b.payTime!.compareTo(a.payTime!));

    return SizedBox(
        height: context.sizeDevice.height,
        child: Column(children: [
          _buildRowTitle(),
          Expanded(child: _buildListItem(groupedOrders))
        ]));
  }

  Widget _buildListItem(List<OrdersGroupByPayTime> groupedOrders) {
    return ListView.builder(
        itemCount: groupedOrders.length,
        itemBuilder: (context, index) {
          final group = groupedOrders[index];
          var totalPrice = 0.0;
          var totalOrder = 0;
          for (var element in group.orders) {
            totalPrice =
                totalPrice + double.parse(element.totalPrice.toString());
            totalOrder++;
          }
          return _buildItem(group, index, totalOrder, totalPrice);
        });
  }

  Widget _buildItem(OrdersGroupByPayTime order, int index, int totalOrder,
      double totalPrice) {
    return InkWell(
      onTap: () => context.pushNamed(RouteName.orderHistoryDetailOnDayScreen,
          extra: order.orders),
      child: _buildRowTitle(
          color: index % 2 == 0
              ? context.colorScheme.primary.withOpacity(0.3)
              : context.colorScheme.primary.withOpacity(0.5),
          column1: (index + 1).toString(),
          column2: Ultils.reverseDate(order.payTime ?? ''),
          column3: totalOrder.toString(),
          column4: Ultils.currencyFormat(totalPrice)),
    );
  }

  Widget _buildRowTitle(
          {String? column1,
          String? column2,
          String? column3,
          String? column4,
          Color? color}) =>
      Container(
        color: color ?? context.colorScheme.primary,
        child: Row(children: [
          _buildTitleTable(column1 ?? 'STT'),
          const SizedBox(width: 1),
          _buildTitleTable(column2 ?? 'Ngày', flex: 3),
          const SizedBox(width: 1),
          _buildTitleTable(column3 ?? 'Tổng đơn', flex: 1),
          const SizedBox(width: 1),
          _buildTitleTable(column4 ?? 'Tổng tiền', flex: 2)
        ]),
      );

  Widget _buildTitleTable(String title, {int? flex}) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
            alignment: Alignment.center,
            height: 40,
            child: Text(title,
                style: context.textStyleSmall!.copyWith(color: Colors.white))));
  }
}
