import 'dart:async';
import 'package:mlt_menu_admin_web/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/features/order/data/provider/remote/order_repo.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

part 'order_event.dart';

typedef Emit = Emitter<GenericBlocState<Orders>>;

class OrderBloc extends Bloc<OrderEvent, GenericBlocState<Orders>>
    with BlocHelper<Orders> {
  OrderBloc() : super(GenericBlocState.loading()) {
    on<OrdersOnTableFecthed>(_getOrderOnTable);
    on<NewOrdersFecthed>(_getNewOrders);
    on<OrdersFecthed>(_getOrders);
    on<OrdersHistoryFecthed>(_getIOrderHistory);
    on<OrdersOnDayFecthed>(_getOrdersOnday);
    on<GetOrdersByID>(_getOrderByID);
    on<OrderUpdated>(_updateOrder);
    on<OrderDeleted>(_deleteOrder);
    // on<AllOrderFetched>(_getAllOrder);
    on<OrderPaymented>(_payOrder);
  }
  final _orderRepository = OrderRepo(
      orderRepository:
          OrderRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getOrderOnTable(OrdersOnTableFecthed event, Emit emit) async {
    await getItemsOnStream(
        _orderRepository.getOrderOnTable(tableID: event.tableID), emit);
  }

  FutureOr<void> _getNewOrders(NewOrdersFecthed event, Emit emit) async {
    await getItemsOnStream(_orderRepository.getNewOrder(), emit);
  }

  FutureOr<void> _getOrders(OrdersFecthed event, Emit emit) async {
    await getItems(
        _orderRepository.getOrdersOnTable(tableID: event.tableID), emit);
  }

  FutureOr<void> _getIOrderHistory(
      OrdersHistoryFecthed event, Emit emit) async {
    await getItems(_orderRepository.getHistoryOrder(), emit);
  }

  FutureOr<void> _getOrderByID(
      GetOrdersByID event, Emitter<GenericBlocState<Orders>> emit) async {
    await getItem(_orderRepository.getOrderByID(orderID: event.orderID), emit);
  }

  FutureOr<void> _updateOrder(OrderUpdated event, Emit emit) async {
    await updateItem(_orderRepository.updateOrder(orders: event.orders), emit);
  }

  FutureOr<void> _deleteOrder(
      OrderDeleted event, Emitter<GenericBlocState<Orders>> emit) async {
    await deleteItem(
        _orderRepository.deleteOrder(orderID: event.orderID), emit);
  }

  // FutureOr<void> _getAllOrder(
  //     AllOrderFetched event, Emitter<GenericBlocState<Orders>> emit) async {
  //   await getItems(_orderRepository.getAllOrder(), emit);
  // }

  FutureOr<void> _payOrder(OrderPaymented event, Emit emit) async {
    await updateItem(
        _orderRepository.paymentOrder(orderID: event.orderID), emit);
  }

  FutureOr<void> _getOrdersOnday(OrdersOnDayFecthed event, Emit emit) async {
    await getItemsOnStream(_orderRepository.getOrdersOnDay(), emit);
  }
}
