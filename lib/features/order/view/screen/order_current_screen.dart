import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin/common/widget/responsive.dart';
import 'package:mlt_menu_admin/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/_print_bottom_sheet.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/model/print_model.dart';
import '../../data/model/food_dto.dart';
import '../../data/model/order_group.dart';
import '../../data/model/order_model.dart';
import 'order_detail_screen.dart';

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
        child: Scaffold(
            body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
              SliverAppBar(
                  stretch: true,
                  pinned: true,
                  automaticallyImplyLeading:
                      Responsive.isDesktop(context) ? false : true,
                  centerTitle: true,
                  title: Text('Đơn hiện tại',
                      style: context.titleStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold))),
              SliverToBoxAdapter(child: OrderHistoryView())
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class OrderHistoryView extends StatelessWidget {
  OrderHistoryView({super.key});
  var _isUsePrint = false;
  final _loading = ValueNotifier(false);

  var _print = PrintModel();

  @override
  Widget build(BuildContext context) {
    _isUsePrint = context.watch<IsUsePrintCubit>().state;
    _print = context.watch<PrintCubit>().state;
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
        Status.success => Responsive(
            mobile: _buildMobile(context, state.datas ?? <Orders>[]),
            tablet: _buildMobile(context, state.datas ?? <Orders>[]),
            desktop: _buildWeb(context, state.datas ?? <Orders>[]))
      });
    }));
  }

  Widget _buildMobile(BuildContext context, List<Orders> orders) {
    return _buildBody(context, orders);
  }

  Widget _buildWeb(BuildContext context, List<Orders> orders) {
    return SizedBox(
        height: context.sizeDevice.height,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: _buildBody(context, orders)),
          const Spacer()
        ]));
  }

  Widget _buildBody(BuildContext context, List<Orders> orders) {
    final groupedOrders = groupOrdersByTable(orders);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: groupedOrders.length,
            itemBuilder: (context, index) {
              final group = groupedOrders[index];
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                            color: context.colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(16)),
                        child: Text('Bàn ăn: ${group.tableName ?? 'Unknown'}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.orders.length,
                        itemBuilder: (context, idx) {
                          final order = group.orders[idx];
                          return _buildItemListView(context, order, idx);
                        })
                  ]);
            }));
  }

  Widget _buildItemListView(
      BuildContext context, Orders orderModel, int index) {
    return Card(
        elevation: 10,
        child: InkWell(
            onTap: () async => await _goToEditOrder(context, orderModel),
            child: SizedBox(
                height: 120,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeaderItem(context, index, orderModel),
                      Expanded(child: _buildBodyItem(context, orderModel))
                    ]))));
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
                    Text('#${index + 1} - ${orders.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(children: [
                      _isUsePrint
                          ? CommonIconButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        content: SizedBox(
                                            width: 600,
                                            child: ValueListenableBuilder(
                                                valueListenable: _loading,
                                                builder: (context, value,
                                                        child) =>
                                                    value
                                                        ? const LoadingScreen()
                                                        : PrintBottomSheet(
                                                            listFoodDto:
                                                                orders.foods,
                                                            onPressedPrint: () {
                                                              context.pop();
                                                              _handlePrint(
                                                                  context,
                                                                  lst: orders
                                                                      .foods,
                                                                  tableID: orders
                                                                          .tableID ??
                                                                      '',
                                                                  tableName: orders
                                                                      .tableName);
                                                            })))));
                              },
                              icon: Icons.print,
                              color: Colors.blueAccent)
                          : const SizedBox(),
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.delete,
                          color: context.colorScheme.errorContainer,
                          onTap: () => _handleDeleteOrder(context, orders))
                    ])
                  ])));
  void _handlePrint(BuildContext context,
      {List<FoodDto>? lst, String? tableID, String? tableName}) async {
    var newList = [];
    for (var element in lst ?? <FoodDto>[]) {
      newList.add(
          '$tableID - $tableName - ${element.foodName} - ${element.quantity} - ${element.totalPrice}');
    }
    logger.d(newList);

    _loading.value = true;
    final toast = FToast()..init(context);
    if (_print.id.isNotEmpty) {
      await Ultils.sendPrintToServer(
              ip: _print.ip, port: _print.port, lst: newList)
          .then((value) {
        _loading.value = false;
        toast
          ..removeQueuedCustomToasts()
          ..showToast(child: AppAlerts.successToast(msg: 'in thành công!'));
      }).onError((error, stackTrace) {
        _loading.value = false;
        toast
          ..removeQueuedCustomToasts()
          ..showToast(child: AppAlerts.errorToast(msg: error.toString()));
      });
    } else {
      _loading.value = false;
      toast
        ..removeQueuedCustomToasts()
        ..showToast(child: AppAlerts.errorToast(msg: 'Chưa chọn máy in!'));
    }
  }

  Future<void> _goToEditOrder(BuildContext context, Orders orders) async {
    // await context.push(RouteName.orderDetail, extra: orders).then((value) {
    //   if (!context.mounted) return;
    //   context.read<OrderBloc>().add(NewOrdersFecthed());
    // });

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SizedBox(
                width: 600, child: OrderDetailScreen(orders: orders))));
  }

  void _handleDeleteOrder(BuildContext context, Orders orders) async {
    // showCupertinoModalPopup<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CommonBottomSheet(
    //           title: "Bạn có muốn xóa đơn này không?",
    //           textConfirm: 'Xóa',
    //           textCancel: "Hủy",
    //           textConfirmColor: context.colorScheme.errorContainer,
    //           onConfirm: () {

    //           });
    //     });

    await AppAlerts.warningDialog(context,
        title: 'Xóa đơn "${orders.id}"?',
        textOk: "Xóa",
        textCancel: 'Hủy',
        desc: 'Kiểm tra kĩ trước khi xóa!',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () {
          showDialog(
              context: context,
              builder: (context) => BlocProvider(
                  create: (context) =>
                      OrderBloc()..add(OrderDeleted(orderID: orders.id ?? '')),
                  child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
                      builder: (context, state) => switch (state.status) {
                            Status.loading => const ProgressDialog(
                                descriptrion: "Đang xóa...",
                                isProgressed: true),
                            Status.empty => const SizedBox(),
                            Status.failure => RetryDialog(
                                title: 'Lỗi',
                                onRetryPressed: () => context
                                    .read<OrderBloc>()
                                    .add(OrderDeleted(
                                        orderID: orders.id ?? ''))),
                            Status.success => ProgressDialog(
                                descriptrion: "Xóa thành công!",
                                isProgressed: false,
                                onPressed: () => pop(context, 1))
                          })));
        });
  }

  _buildBodyItem(BuildContext context, Orders orderModel) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        // _buildColumnValueItem(title: 'ID', value: orderModel.id ?? ''),
        _buildColumnValueItem(title: 'Bàn', value: orderModel.tableName),
        _buildColumnValueItem(
            title: 'Đặt lúc',
            value: Ultils.formatDateTime(
                orderModel.orderTime ?? DateTime.now().toString())),
        _buildPrice(
            context,
            Ultils.currencyFormat(
                double.parse(orderModel.totalPrice?.toString() ?? '0')))
      ]));

  Widget _buildPrice(BuildContext context, String price) {
    return Expanded(
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng tiền',
                      style: TextStyle(color: Colors.white.withOpacity(0.3))),
                  Text(price,
                      style: context.textStyleLarge!.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold))
                ])));
  }

  Widget _buildColumnValueItem({required String title, required String value}) {
    return Expanded(
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(color: Colors.white.withOpacity(0.3))),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ])));
  }
}
