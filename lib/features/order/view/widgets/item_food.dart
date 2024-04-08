import 'package:flutter/material.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../../../core/utils/utils.dart';
import '../../data/model/food_dto.dart';

class ItemFood extends StatelessWidget {
  const ItemFood(
      {super.key,
      required this.quantity,
      required this.totalPriceFood,
      required this.foodDto,
      required this.onTapIncrement,
      required this.onTapDecrement,
      required this.onPressed,
      required this.index});
  final FoodDto foodDto;
  final ValueNotifier<int> quantity;
  final ValueNotifier<num> totalPriceFood;
  final void Function()? onTapIncrement;
  final void Function()? onTapDecrement;
  final void Function()? onPressed;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
              height: 40,
              width: double.infinity,
              color: context.colorScheme.primary.withOpacity(0.3),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#${index + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        CommonIconButton(
                            onTap: onPressed,
                            color: context.colorScheme.errorContainer,
                            icon: Icons.delete)
                      ]))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              _buildImage(foodDto),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(),
                Text(foodDto.foodName),
                SizedBox(height: defaultPadding / 2),
                _buildQuality(context, foodDto)
              ])
            ]),
            Column(children: [
              Padding(
                  padding: EdgeInsets.only(right: defaultPadding / 2),
                  child: ValueListenableBuilder(
                      valueListenable: totalPriceFood,
                      builder: (context, value, child) =>
                          _PriceFoodItem(totalPrice: value.toString()))),
              const SizedBox(height: 8)
            ])
          ]),
          foodDto.note.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Text("Ghi chú: "),
                        Text(foodDto.note,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.3)))
                      ]))
              : const SizedBox()
        ]));
  }

  Widget _buildQuality(BuildContext context, FoodDto foodDto) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: onTapDecrement,
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      ValueListenableBuilder(
          valueListenable: quantity,
          builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text('$value'))),
      InkWell(
          onTap: onTapIncrement,
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
  }

  Widget _buildImage(FoodDto food) {
    return Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(
                    food.foodImage == "" ? noImage : food.foodImage),
                fit: BoxFit.cover)));
  }
}

class _PriceFoodItem extends StatelessWidget {
  final String totalPrice;

  const _PriceFoodItem({required this.totalPrice});
  // food.totalPrice.toString()
  @override
  Widget build(BuildContext context) {
    return Text(Ultils.currencyFormat(double.parse(totalPrice)),
        style: TextStyle(
            color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
  }
}
