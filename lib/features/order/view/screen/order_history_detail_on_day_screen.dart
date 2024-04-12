import 'package:flutter/material.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_history_detail_screen.dart';
import '../../../../core/utils/utils.dart';
import '../../data/model/order_model.dart';

class OrderHistoryDetailOnDayScreen extends StatelessWidget {
  const OrderHistoryDetailOnDayScreen({super.key, required this.orders});

  final List<Orders> orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: context.sizeDevice.height,
                child: Column(children: [
                  _buildRowTitle(context),
                  Expanded(child: _buildListItem(orders))
                ]))));
  }

  Widget _buildListItem(List<Orders> orders) {
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _buildItem1(context, orders[index], index);
        });
  }

  Widget _buildItem1(BuildContext context, Orders order, int index) {
    return InkWell(
        onTap: () => _showDialog(context, order),
        child: _buildRowTitle(context,
            color: index % 2 == 0
                ? context.colorScheme.primary.withOpacity(0.3)
                : context.colorScheme.primary.withOpacity(0.5),
            column1: (index + 1).toString(),
            column2: order.tableName,
            column3: Ultils.formatDateTime(order.orderTime ?? ''),
            column4: Ultils.formatDateTime(order.payTime ?? ''),
            column5: Ultils.currencyFormat(order.totalPrice!.toDouble())));
  }

  Widget _buildRowTitle(BuildContext context,
          {String? column1,
          String? column2,
          String? column3,
          String? column4,
          String? column5,
          Color? color}) =>
      Container(
          color: color ?? context.colorScheme.primary,
          child: Row(children: [
            _buildTitleTable(context, column1 ?? 'STT'),
            const SizedBox(width: 1),
            _buildTitleTable(context, column2 ?? 'Bàn'),
            const SizedBox(width: 1),
            _buildTitleTable(context, column3 ?? 'Đặt lúc', flex: 2),
            const SizedBox(width: 1),
            _buildTitleTable(context, column4 ?? 'Thanh toán lúc', flex: 2),
            const SizedBox(width: 1),
            _buildTitleTable(context, column5 ?? 'Tổng tiền')
          ]));

  Widget _buildTitleTable(BuildContext context, String title, {int? flex}) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
            alignment: Alignment.center,
            height: 40,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(title,
                  style: context.textStyleSmall!.copyWith(color: Colors.white)),
            )));
  }

  _buildAppbar(BuildContext context) => AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
          'Tổng đơn ngày: ${Ultils.reverseDate(orders.first.payTime ?? '')}',
          style: context.titleStyleMedium));

  _showDialog(BuildContext context, Orders orders) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
            content: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SizedBox(
                    width: 600,
                    child: OrderHistoryDetailScreen(orders: orders)))));
  }
}
