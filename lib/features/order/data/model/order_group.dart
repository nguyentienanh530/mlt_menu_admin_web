import 'package:collection/collection.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';

import '../../../../core/utils/utils.dart';

class OrdersGroupByPayTime {
  final String? payTime;
  final List<Orders> orders;

  OrdersGroupByPayTime({required this.payTime, required this.orders});
}

List<OrdersGroupByPayTime> groupOrdersByPayTime(List<Orders> ordersList) {
  final groupedOrders = groupBy<Orders, String?>(
      ordersList, (order) => Ultils.formatToDate(order.payTime!));
  return groupedOrders.entries
      .map((entry) =>
          OrdersGroupByPayTime(payTime: entry.key, orders: entry.value))
      .toList();
}

class OrdersGroupByTable {
  final String? tableName;
  final List<Orders> orders;

  OrdersGroupByTable({required this.tableName, required this.orders});
}

List<OrdersGroupByTable> groupOrdersByTable(List<Orders> ordersList) {
  final groupedOrders =
      groupBy<Orders, String?>(ordersList, (order) => order.tableName);
  return groupedOrders.entries
      .map((entry) =>
          OrdersGroupByTable(tableName: entry.key, orders: entry.value))
      .toList();
}
