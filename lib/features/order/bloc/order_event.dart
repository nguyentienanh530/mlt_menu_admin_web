part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class OrdersOnTableFecthed extends OrderEvent {
  final String? tableID;

  const OrdersOnTableFecthed({required this.tableID});
}

final class NewOrdersFecthed extends OrderEvent {}

final class OrdersFecthed extends OrderEvent {
  final String tableID;

  const OrdersFecthed({required this.tableID});
}

final class OrdersHistoryFecthed extends OrderEvent {}

final class OrdersOnDayFecthed extends OrderEvent {}

final class GetOrdersByID extends OrderEvent {
  final String orderID;

  const GetOrdersByID({required this.orderID});
}

final class OrderUpdated extends OrderEvent {
  final Orders orders;

  const OrderUpdated({required this.orders});
}

final class OrderDeleted extends OrderEvent {
  final String orderID;

  const OrderDeleted({required this.orderID});
}

// final class AllOrderFetched extends OrderEvent {}

final class OrderPaymented extends OrderEvent {
  final String orderID;

  const OrderPaymented({required this.orderID});
}
