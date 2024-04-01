import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({super.key});

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => OrderBloc()..add(NewOrdersFecthed()),
        child: Scaffold(body: OrderHistoryView()));
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class OrderHistoryView extends StatelessWidget {
  OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonRefreshIndicator(onRefresh: () async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!context.mounted) return;
      context.read<OrderBloc>().add(NewOrdersFecthed());
    }, child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
        builder: (context, state) {
      return (switch (state.status) {
        Status.loading => const LoadingScreen(),
        Status.empty => const EmptyScreen(),
        Status.failure => ErrorScreen(errorMsg: state.error),
        Status.success => _buildBody(context, state.datas as List<Orders>)
      });
    }));
  }

  Widget _buildBody(BuildContext context, List<Orders> orders) {
    return GroupedListView(
        physics: const AlwaysScrollableScrollPhysics(),
        elements: orders,
        groupBy: (element) => element.tableName,
        itemComparator: (element1, element2) =>
            element2.tableID!.compareTo(element1.tableID!),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (String value) {
          return Container(
              width: context.sizeDevice.width * 3 / 4,
              decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(defaultBorderRadius)),
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.all(defaultPadding),
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: context.titleStyleMedium!.copyWith(
                      color: context.colorScheme.tertiary,
                      fontWeight: FontWeight.bold)));
        },
        indexedItemBuilder: (context, element, index) {
          return _buildItemListView(context, element, index)
              .animate()
              .slideX(
                  begin: -0.1,
                  end: 0,
                  curve: Curves.easeInOutCubic,
                  duration: 500.ms)
              .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
        });
  }

  Widget _buildItemListView(
      BuildContext context, Orders orderModel, int index) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 10,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderItem(context, index, orderModel),
              _buildBodyItem(orderModel)
            ]));
  }

  Widget _buildHeaderItem(BuildContext context, int index, Orders orders) =>
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
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.edit,
                          onTap: () async =>
                              await _goToEditOrder(context, orders)),
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.delete,
                          color: context.colorScheme.errorContainer,
                          onTap: () =>
                              _handleDeleteOrder(context, orders.id ?? ''))
                    ])
                  ])));

  Future<void> _goToEditOrder(BuildContext context, Orders orders) async =>
      await context.push(RouteName.orderDetail, extra: orders).then((value) {
        if (!context.mounted) return;
        context.read<OrderBloc>().add(NewOrdersFecthed());
      });

  void _handleDeleteOrder(BuildContext context, String idOrder) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CommonBottomSheet(
              title: "Bạn có muốn xóa đơn này không?",
              textConfirm: 'Xóa',
              textCancel: "Hủy",
              textConfirmColor: context.colorScheme.errorContainer,
              onConfirm: () {
                context.read<OrderBloc>().add(OrderDeleted(orderID: idOrder));
                showDialog(
                    context: context,
                    builder: (context) =>
                        BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
                            builder: (context, state) => switch (state.status) {
                                  Status.loading => const ProgressDialog(
                                      descriptrion: "Đang xóa...",
                                      isProgressed: true),
                                  Status.empty => const SizedBox(),
                                  Status.failure => RetryDialog(
                                      title: 'Lỗi',
                                      onRetryPressed: () => context
                                          .read<OrderBloc>()
                                          .add(OrderDeleted(orderID: idOrder))),
                                  Status.success => ProgressDialog(
                                      descriptrion: "Xóa thành công!",
                                      isProgressed: false,
                                      onPressed: () => pop(context, 2))
                                }));
              });
        });
  }

  _buildBodyItem(Orders orderModel) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonLineText(title: 'ID: ', value: orderModel.id ?? ''),
            const SizedBox(height: 8.0),
            CommonLineText(title: 'Bàn: ', value: orderModel.tableName),
            const SizedBox(height: 8.0),
            CommonLineText(
                title: 'Đặt lúc: ',
                value: Ultils.formatDateTime(
                    orderModel.orderTime ?? DateTime.now().toString()))
          ]));
}
