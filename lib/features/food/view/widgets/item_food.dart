import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../../../core/utils/utils.dart';
import '../../data/model/food_model.dart';

class ItemFood extends StatelessWidget {
  const ItemFood(
      {super.key,
      required this.food,
      required this.onTapView,
      required this.index,
      required this.onTapDeleteFood,
      required this.onTapEditFood});

  final Food food;
  final void Function()? onTapView;
  final void Function()? onTapDeleteFood;
  final void Function()? onTapEditFood;
  final int index;

  @override
  Widget build(BuildContext context) {
    return _buildItemSearch(context, food);
  }

  Widget _buildItemSearch(BuildContext context, Food food) {
    return LayoutBuilder(
        builder: (context, constraints) => Card(
            elevation: 10,
            child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(children: [
                  Expanded(child: _buildHeader(context, food)),
                  Expanded(
                    flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: _buildImage(food)),
                          Expanded(
                              child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                Expanded(child: _buildTitle(context, food)),
                                Expanded(child: _buildPrice(context, food))
                              ]))
                        ]
                            .animate(interval: 50.ms)
                            .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)
                            .fadeIn(
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)),
                  )
                ]))));
  }

  Widget _buildHeader(BuildContext context, Food food) => Container(
      color: context.colorScheme.primary.withOpacity(0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('#${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              food.isShowFood
                  ? CommonIconButton(onTap: onTapView, color: Colors.green)
                  : CommonIconButton(
                      icon: Icons.visibility_off,
                      onTap: onTapView,
                      color: Colors.red),
              const SizedBox(width: 8),
              CommonIconButton(icon: Icons.edit, onTap: onTapEditFood),
              const SizedBox(width: 8),
              CommonIconButton(
                  icon: Icons.delete,
                  color: context.colorScheme.errorContainer,
                  onTap: onTapDeleteFood)
            ])
          ])));

  Widget _buildImage(Food food) {
    return Container(
        margin: EdgeInsets.all(defaultPadding / 2),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(food.image == "" ? noImage : food.image),
                fit: BoxFit.cover)));
  }

  Widget _buildCategory(BuildContext context, Food food) {
    return FittedBox(child: Text('asdasd', style: context.textStyleSmall!));
  }

  Widget _buildTitle(BuildContext context, Food food) {
    return FittedBox(child: Text(food.name));
  }

  Widget _buildPrice(BuildContext context, Food food) {
    double discountAmount = (food.price * food.discount.toDouble()) / 100;
    double discountedPrice = food.price - discountAmount;
    return food.isDiscount == false
        ? FittedBox(
            child: Text(
                Ultils.currencyFormat(double.parse(food.price.toString())),
                style: TextStyle(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.bold)),
          )
        : FittedBox(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      Ultils.currencyFormat(
                          double.parse(food.price.toString())),
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3.0,
                          decorationColor: Colors.red,
                          decorationStyle: TextDecorationStyle.solid,
                          // fontSize: defaultSizeText,
                          color: Color.fromARGB(255, 131, 128, 126),
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 10.0),
                  Text(
                      Ultils.currencyFormat(
                          double.parse(discountedPrice.toString())),
                      style: TextStyle(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold))
                ]),
          );
  }

  // Widget _buildPercentDiscount(Food food) {
  //   return SizedBox(
  //       height: 80,
  //       width: 80,
  //       // decoration: BoxDecoration(color: redColor),
  //       child: Center(child: CommonLineText(value: "${food.discount}%")

  //           // Text("${food.discount}%",
  //           //     style: TextStyle(
  //           //         fontSize: 16,
  //           //         color: textColor,
  //           //         fontFamily: Constant.font,
  //           //         fontWeight: FontWeight.w600)))
  //           ));
  // }
}
