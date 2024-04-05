import 'package:flutter/cupertino.dart';
import 'package:mlt_menu_admin_web/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/food_dto.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../common/dialog/app_alerts.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/model/print_model.dart';

// ignore: must_be_immutable
class OrderHistoryDetailScreen extends StatelessWidget {
  OrderHistoryDetailScreen({super.key, required this.orders});
  final Orders orders;
  final _loading = ValueNotifier(false);
  var _isUsePrint = false;
  var _print = PrintModel();

  @override
  Widget build(BuildContext context) {
    _isUsePrint = context.watch<IsUsePrintCubit>().state;
    _print = context.watch<PrintCubit>().state;
    return ValueListenableBuilder(
        valueListenable: _loading,
        builder: (context, value, child) => value
            ? const LoadingScreen()
            : Column(children: [
                _buildAppbar(context),
                Expanded(child: OrderHistoryDetailView(orders: orders))
              ]));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chi tiết đơn hàng', style: context.titleStyleMedium),
        centerTitle: true,
        actions: [
          _isUsePrint
              ? CommonIconButton(
                  onTap: () {
                    _handlePrint(context, orders.foods);
                  },
                  icon: Icons.print)
              : const SizedBox(),
          const SizedBox(width: 8)
        ]);
  }

  void _handlePrint(BuildContext context, List<FoodDto> lst) async {
    var newList = [];
    for (var element in lst) {
      newList.add(
          '${orders.tableID} - ${orders.tableName} - ${element.foodName} - ${element.quantity} - ${element.totalPrice}');
    }

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
}

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key, required this.orders});
  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Thời gian đặt:"),
            Text(Ultils.formatDateTime(orders.orderTime!))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Thời gian thanh toán:"),
            Text(Ultils.formatDateTime(orders.payTime!))
          ]),
          SizedBox(height: defaultPadding),
          Table(
              border: TableBorder.all(
                  color: context.colorScheme.primary, width: 0.3),
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(context.sizeDevice.width * 0.5),
                1: FlexColumnWidth(context.sizeDevice.width * 0.0015),
                2: const FlexColumnWidth()
              },
              children: [
                TableRow(children: <Widget>[
                  Container(
                      height: 40,
                      alignment: Alignment.center,
                      color: context.colorScheme.primary,
                      child: const Text("Món")),
                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      color: context.colorScheme.primary,
                      child: const Text("Số lượng")),
                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      color: context.colorScheme.primary,
                      child: const Text("Giá"))
                ])
              ]),
          Table(
              border: TableBorder.all(
                  color: context.colorScheme.primary, width: 0.3),
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(context.sizeDevice.width * 0.5),
                1: FlexColumnWidth(context.sizeDevice.width * 0.0015),
                2: const FlexColumnWidth()
              },
              children:
                  orders.foods.map((e) => _buildTable(context, e)).toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Tổng tiền:"),
            Text(Ultils.currencyFormat(
                double.parse(orders.totalPrice.toString())))
          ])
        ]));
  }

  TableRow _buildTable(BuildContext context, FoodDto food) {
    return TableRow(children: <Widget>[
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5),
          height: 40,
          child: FittedBox(child: Text(food.foodName))),
      Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 40,
          child: FittedBox(child: Text(food.quantity.toString()))),
      Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 40,
          child: FittedBox(
              child: Text(Ultils.currencyFormat(
                  double.parse(food.totalPrice.toString())))))
    ]);
  }
}
