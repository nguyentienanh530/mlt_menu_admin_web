import 'package:flutter/material.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_history_detail_screen.dart';
import '../../../../common/widget/common_icon_button.dart';
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
            child: GridView.builder(
                itemCount: orders.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: countGridView(context),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16),
                itemBuilder: (context, index) {
                  return _buildItem(context, orders[index], index);
                })));
  }

  _buildAppbar(BuildContext context) => AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
          'Tổng đơn ngày: ${Ultils.reverseDate(orders.first.payTime ?? '')}',
          style: context.titleStyleMedium));

  Widget _buildItem(BuildContext context, Orders order, int index) {
    return Card(
        elevation: 10,
        child: Column(children: [
          _buildHeaderItem(context, order, index),
          Expanded(
              child: Column(children: [
            Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      _buildLineValueItem(title: 'ID', value: order.id ?? ''),
                      _buildLineValueItem(
                          title: 'Bàn sử dụng', value: order.tableName),
                      _buildLineValueItem(
                          title: 'Thời gian đặt',
                          value: Ultils.formatDateTime(order.orderTime ?? '')),
                      _buildLineValueItem(
                          title: 'Thời gian thanh toán',
                          value: Ultils.formatDateTime(order.payTime ?? ''))
                    ]))),
            Divider(color: context.colorScheme.primary.withOpacity(0.3)),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildPrice(context,
                        Ultils.currencyFormat(order.totalPrice!.toDouble()))))
          ]))
        ]));
  }

  Widget _buildHeaderItem(BuildContext context, Orders orders, int index) {
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
                      onTap: () => _showDialog(context, orders),
                      color: Colors.green,
                      icon: Icons.remove_red_eye)
                ])));
  }

  Widget _buildLineValueItem({required String title, required String value}) {
    return Expanded(
        child: FittedBox(
            child: Column(children: [
      FittedBox(
          child: Text(title,
              style: TextStyle(color: Colors.white.withOpacity(0.3)))),
      FittedBox(
          child: Text(value,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)))
    ])));
  }

  Widget _buildPrice(BuildContext context, String price) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Tổng tiền:',
          style: TextStyle(color: Colors.white.withOpacity(0.3))),
      Text(price,
          style: context.textStyleLarge!.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.bold))
    ]);
  }

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
