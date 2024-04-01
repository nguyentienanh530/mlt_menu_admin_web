import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin_web/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin_web/common/widget/common_bottomsheet.dart';
import 'package:mlt_menu_admin_web/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
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
import 'package:grouped_list/grouped_list.dart';
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
    var orderState = context.watch<OrderBloc>().state;
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          getData();
        },
        child: (switch (orderState.status) {
          Status.loading => const LoadingScreen(),
          Status.empty => const EmptyScreen(),
          Status.failure => ErrorScreen(errorMsg: orderState.error),
          Status.success =>
            _buildBody(context, orderState.datas as List<Orders>)
        }));
  }

  Widget _buildBody(BuildContext context, List<Orders> orders) {
    return GroupedListView(
        physics: const BouncingScrollPhysics(),
        elements: orders,
        groupBy: (element) => Ultils.formatToDate(element.payTime!),
        itemComparator: (element1, element2) =>
            element2.payTime!.compareTo(element1.payTime!),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (String value) {
          var totalPrice = 0.0;
          for (var element in orders) {
            if (Ultils.formatToDate(element.payTime!) == value) {
              totalPrice =
                  totalPrice + double.parse(element.totalPrice.toString());
            }
          }
          return Container(
              width: context.sizeDevice.width * 3 / 4,
              decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(defaultBorderRadius)),
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.all(defaultPadding),
              child: Text(
                  '${Ultils.reverseDate(value)} - ${Ultils.currencyFormat(totalPrice)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.colorScheme.tertiary,
                      fontWeight: FontWeight.bold)));
        },
        indexedItemBuilder: (context, element, index) {
          return _buildItemListView(context, element, index);
        });
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
