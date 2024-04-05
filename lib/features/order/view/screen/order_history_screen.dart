import 'package:flutter/widgets.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin_web/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin_web/common/widget/common_bottomsheet.dart';
import 'package:mlt_menu_admin_web/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_group.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => OrderBloc(),
        child: const Scaffold(body: OrderHistoryView()));
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
        Status.success => _buildBody(orderState.datas as List<Orders>)
      });
    });
  }

  Widget _buildBody(List<Orders> orders) {
    final groupedOrders = groupOrdersByPayTime(orders);
    groupedOrders.sort((a, b) => b.payTime!.compareTo(a.payTime!));

    return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: countGridView(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16),
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
              return Card(
                  elevation: 10,
                  child: Column(children: [
                    _buildHeaderItem(group.orders, index),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          Expanded(
                              flex: 2,
                              child: _buildBodyItem(group, totalOrder)),
                          Divider(
                              color:
                                  context.colorScheme.primary.withOpacity(0.3)),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildPrice(
                                      Ultils.currencyFormat(totalPrice))))
                        ]))
                  ]));
              // Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //      ,
              //       // GridView.builder(
              //       //     shrinkWrap: true,
              //       //     physics: const NeverScrollableScrollPhysics(),
              //       //     itemCount: group.orders.length,
              //       //     itemBuilder: (context, idx) {
              //       //       final order = group.orders[idx];
              //       //       return _buildItemListView(context, order, idx);
              //       //     },
              //       //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       //         crossAxisCount: countGridView(context)))
              //     ]);
            }));
  }

  Widget _buildBodyItem(OrdersGroupByPayTime group, int totalOrder) {
    columnInItem(String title, value) =>
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildTitle(title),
          const SizedBox(height: 8),
          _buildValue(value)
        ]);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: columnInItem('Ngày', Ultils.reverseDate(group.payTime ?? ''))),
      Expanded(child: columnInItem('Tổng đơn', totalOrder.toString()))
    ]);
  }

  Widget _buildTitle(String title) {
    return Text(title,
        style: context.textStyleSmall!
            .copyWith(color: Colors.white.withOpacity(0.3)));
  }

  Widget _buildValue(String title) {
    return Text(title,
        style: context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildHeaderItem(List<Orders> orders, int index) {
    return Container(
        height: 40,
        width: double.infinity,
        color: context.colorScheme.primary.withOpacity(0.3),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  CommonIconButton(
                      onTap: () => context.push(
                          RouteName.orderHistoryDetailOnDayScreen,
                          extra: orders),
                      color: Colors.green,
                      icon: Icons.remove_red_eye)
                ])));
  }

  Widget _buildPrice(String price) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _buildTitle('Tổng tiền:'),
      Text(price,
          style: context.textStyleLarge!.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.bold))
    ]);
  }

  Widget _buildItemListView(
      BuildContext context, Orders orderModel, int index) {
    return Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          _buildHeader(context, index, orderModel),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonLineText(title: 'ID: ', value: orderModel.id!),
                          CommonLineText(
                              title: 'Bàn: ', value: orderModel.tableName),
                          CommonLineText(
                              title: 'Thời gian đặt: ',
                              value:
                                  Ultils.formatDateTime(orderModel.orderTime!)),
                          CommonLineText(
                              title: 'Thời thanh toán: ',
                              value: Ultils.formatDateTime(orderModel.payTime!))
                        ])
                  ]))
        ]));
  }

  Widget _buildHeader(BuildContext context, int index, Orders orders) =>
      Container(
          height: 40,
          color: context.colorScheme.primary.withOpacity(0.3),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text('#${index + 1} - ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          Ultils.currencyFormat(double.parse(
                              orders.totalPrice?.toString() ?? '0')),
                          style: TextStyle(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.bold))
                    ]),
                    Row(children: [
                      CommonIconButton(
                          onTap: () => context.push(
                              RouteName.orderHistoryDetail,
                              extra: orders)),
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.delete,
                          color: context.colorScheme.errorContainer,
                          onTap: () =>
                              _openBottomSheetDeleteOrder(context, orders))
                    ])
                  ])));

  _openBottomSheetDeleteOrder(BuildContext context, Orders orders) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Bạn có muốn xóa đơn này không?',
            textCancel: 'Hủy',
            textConfirm: 'Xóa',
            onConfirm: () {
              context.pop();
              _handleDeleteOrder(context, orders);
            }));
  }

  void _handleDeleteOrder(BuildContext context, Orders orders) {
    context.read<OrderBloc>().add(OrderDeleted(orderID: orders.id ?? ''));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            // buildWhen: (previous, current) =>
            //     context.read<OrderBloc>().operation == ApiOperation.delete,
            builder: (context, state) => switch (state.status) {
                  Status.loading => const ProgressDialog(
                      descriptrion: "Đang xóa...", isProgressed: true),
                  Status.empty => const SizedBox(),
                  Status.failure => RetryDialog(
                      title: 'Lỗi',
                      onRetryPressed: () => context
                          .read<OrderBloc>()
                          .add(OrderDeleted(orderID: orders.id ?? ''))),
                  Status.success => ProgressDialog(
                      descriptrion: "Xóa thành công",
                      isProgressed: false,
                      onPressed: () {
                        getData();
                        context.pop();
                      })
                }));
  }
}
