import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/features/order/data/provider/remote/order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mlt_menu_admin/features/order/data/model/food_dto.dart';
import 'package:mlt_menu_admin/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin/features/order/view/screen/add_food_to_order_screen.dart';
import 'package:order_repository/order_repository.dart';
import '../../bloc/order_bloc.dart';
import '../widgets/item_food.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orders});
  final Orders orders;
  @override
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildAppbar(context),
      const SizedBox(height: 8),
      Expanded(child: OrderDetailView(orders: orders))
    ]);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(orders.id!, style: context.titleStyleMedium),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.highlight_remove_rounded))
        ]);
  }
}

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  OrderDetailView({super.key, required this.orders});
  Orders orders;
  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  var orders = Orders();
  final _totalPrice = ValueNotifier<num>(0.0);
  // var _ordersState = GenericBlocState<Orders>();
  @override
  void initState() {
    orders = widget.orders;
    _totalPrice.value = orders.totalPrice ?? 0.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(children: [
          Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.foods.length,
                  itemBuilder: (context, index) => _buildItem(
                          orders.foods[index], index)
                      .animate()
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          curve: Curves.easeInOutCubic,
                          duration: 500.ms)
                      .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))),
          _buildBottomAction()
        ]));
  }

  Widget _buildItem(FoodDto foodDto, int index) {
    final quantity = ValueNotifier(foodDto.quantity);
    final totalPriceFood = ValueNotifier(foodDto.totalPrice);
    return ItemFood(
        index: index,
        onPressed: () => _handleDeleteItem(foodDto),
        totalPriceFood: totalPriceFood,
        quantity: quantity,
        foodDto: foodDto,
        onTapIncrement: () {
          quantity.value++;
          totalPriceFood.value = quantity.value * foodDto.foodPrice;
          _handleUpdate(foodDto, quantity.value);
        },
        onTapDecrement: () {
          if (quantity.value > 1) {
            quantity.value--;
            totalPriceFood.value = quantity.value * foodDto.foodPrice;
            _handleUpdate(foodDto, quantity.value);
          }
        });
  }

  void _handleUpdate(FoodDto foodDto, int quantity) {
    foodDto = foodDto.copyWith(
        quantity: quantity, totalPrice: quantity * foodDto.foodPrice);
    orders = orders.copyWith(
        foods: orders.foods.map((element) {
      if (element.foodID == foodDto.foodID) {
        return element.copyWith(
            quantity: foodDto.quantity, totalPrice: foodDto.totalPrice);
      }
      return element;
    }).toList());
    _totalPrice.value = 0;
    for (FoodDto foo in orders.foods) {
      _totalPrice.value += foo.totalPrice;
    }
    orders = orders.copyWith(totalPrice: _totalPrice.value);
    OrderRepo(
            orderRepository:
                OrderRepository(firebaseFirestore: FirebaseFirestore.instance))
        .updateOrder(orders: orders);
  }

  void _handleDeleteItem(FoodDto foodDto) async {
    await AppAlerts.warningDialog(context,
        title: 'Xóa món "${foodDto.foodName}"?',
        desc: 'Kiểm tra kĩ trước khi xóa!',
        textOk: 'Xóa',
        textCancel: 'Hủy',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () {
          var foods = <FoodDto>[];
          foods.addAll(orders.foods);
          var totalPrice = 0.0;
          foods.removeWhere((element) => element.foodID == foodDto.foodID);

          for (FoodDto foo in foods) {
            totalPrice += foo.totalPrice;
          }
          setState(() {
            orders = orders.copyWith(foods: foods, totalPrice: totalPrice);
          });

          context.read<OrderBloc>().add(OrderUpdated(orders: orders));
          // context.pop();
        }).then((value) => _totalPrice.value = orders.totalPrice!);
  }

  Widget _buildBottomAction() {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Tổng tiền:"),
                ValueListenableBuilder(
                    valueListenable: _totalPrice,
                    builder: (context, value, child) => Text(
                        Ultils.currencyFormat(double.parse(value.toString())),
                        style: TextStyle(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold)))
              ]),
              SizedBox(height: defaultPadding),
              orders.foods.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(child: _buildPaymentAccepted()),
                      SizedBox(width: defaultPadding / 3),
                      Expanded(child: _buildButtonAddFood())
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildButtonAddFood()])
            ])));
  }

  Widget _buildPaymentAccepted() {
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(context.colorScheme.primary)),
        icon: const Icon(Icons.payment_outlined, size: 15),
        label: FittedBox(
          child: Text("Thanh toán", style: context.titleStyleMedium),
        ),
        onPressed: () => _handleButtonAccepted(context));
  }

  Future<void> _handleButtonAccepted(BuildContext context) async {
    // showCupertinoModalPopup<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CommonBottomSheet(
    //           title: "Xác nhận thanh toán?",
    //           textConfirm: 'Thanh toán',
    //           textCancel: "Hủy",
    //           onConfirm: () {
    //             pop(context, 1);
    //             handlePaymentSubmited();
    //           });
    //     });

    await AppAlerts.warningDialog(context,
        title: 'Thanh Toán',
        desc: 'Kiểm tra kĩ trước khi thanh toán!',
        textCancel: 'Hủy',
        textOk: 'Thanh toán',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () {
          pop(context, 1);
          handlePaymentSubmited();
        });
  }

  void handlePaymentSubmited() {
    context.read<OrderBloc>().add(OrderPaymented(orderID: orders.id!));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => const ProgressDialog(
                      descriptrion: 'Đang thanh toán...', isProgressed: true),
                  Status.empty => const EmptyScreen(),
                  Status.failure => RetryDialog(
                      title: 'Có lỗi xảy ra!',
                      onRetryPressed: () => context
                          .read<OrderBloc>()
                          .add(OrderPaymented(orderID: orders.id!))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Thanh toán thành công',
                      isProgressed: false,
                      onPressed: () {
                        pop(context, 1);
                      })
                }));
  }

  Widget _buildButtonAddFood() {
    final FToast fToast = FToast()..init(context);
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                context.colorScheme.secondaryContainer)),
        icon: const Icon(Icons.add_box_rounded, size: 15),
        label:
            FittedBox(child: Text('Thêm món', style: context.titleStyleMedium)),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                    content:
                        SizedBox(width: 600, child: AddFoodToOrderScreen()));
              }).then((value) {
            if (value is FoodDto) {
              if (!checkExistFood(food: value)) {
                _handleAddFood(value);
              } else {
                fToast.showToast(
                    child: AppAlerts.errorToast(msg: 'Món ăn đã có trong đơn'));
              }
            }
            return setState(() {});
          });
        });
  }

  bool checkExistFood({FoodDto? food}) {
    var isExist = false;
    for (FoodDto e in orders.foods) {
      if (e.foodID == food!.foodID) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  void _handleAddFood(FoodDto foodDto) {
    List<FoodDto> foods = [...orders.foods, foodDto];

    var totalPrice = 0.0;
    for (FoodDto foo in foods) {
      totalPrice += foo.totalPrice;
    }
    orders = orders.copyWith(foods: foods, totalPrice: totalPrice);
    OrderRepo(
            orderRepository:
                OrderRepository(firebaseFirestore: FirebaseFirestore.instance))
        .updateOrder(orders: orders);
  }
}
