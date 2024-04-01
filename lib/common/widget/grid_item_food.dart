// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../app_export.dart';

// class GridItemFood extends StatelessWidget {
//   final List<FoodModel>? list;

//   GridItemFood({super.key, required this.list});
//   Widget _buildImage(FoodModel food) {
//     return Hero(
//         tag: 'hero-tag-${food.id}+grid',
//         child: Material(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.circular(defaultBorderRadius),
//             child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(defaultBorderRadius),
//                     image: DecorationImage(
//                         image: NetworkImage(
//                             food.image == null || food.image == ""
//                                 ? noImage
//                                 : food.image!),
//                         fit: food.isImageCrop == true
//                             ? BoxFit.cover
//                             : BoxFit.fill)))));
//   }

//   Widget _buildPercentDiscount(FoodModel food) {
//     return Container(
//         height: 30,
//         width: 50,
//         decoration: BoxDecoration(
//             color: kRedColor,
//             borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(defaultBorderRadius),
//                 topLeft: Radius.circular(defaultBorderRadius))),
//         child: Center(
//             child: Text("${food.discount}%",
//                 style: MyTextStyle.normal(fontSize: kTextSizeSmall - 2))));
//   }

//   Widget _buildTitle(FoodModel food) {
//     return FittedBox(
//       alignment: Alignment.centerLeft,
//       child: Text(food.title!,
//           overflow: TextOverflow.ellipsis,
//           style: MyTextStyle.bold(
//               fontSize: kTextSizeSmall - 2, textColor: kSecondaryTextColor)),
//     );
//   }

//   Widget _buildPriceDiscount(FoodModel food) {
//     double discountAmount = (food.price! * food.discount!.toDouble()) / 100;
//     double discountedPrice = food.price! - discountAmount;
//     return food.isDiscount == false
//         ? Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//                 Expanded(
//                     flex: 2,
//                     child: FittedBox(
//                       alignment: Alignment.bottomLeft,
//                       child: Text(
//                           Ultils.currencyFormat(
//                               double.parse(food.price.toString())),
//                           style: MyTextStyle.bold(textColor: kAccentColor)),
//                     )),
//                 Expanded(
//                     child: FittedBox(
//                         alignment: Alignment.bottomRight,
//                         child: _buildButtonCart(food)))
//               ])
//         : Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//                 // Text(Ultils.currencyFormat(double.parse(food.price.toString())),
//                 //     style:  TextStyle(
//                 //         fontFamily: font,
//                 //         decoration: TextDecoration.lineThrough,
//                 //         decorationThickness:
//                 //             3.0, // Opsional, mengatur tebal garis coret
//                 //         decorationColor:
//                 //             Colors.red, // Opsional, mengatur warna garis coret
//                 //         decorationStyle: TextDecorationStyle
//                 //             .solid, // Opsional, mengatur gaya garis coret

//                 //         fontSize: 22.5,
//                 //         color: Color.fromARGB(255, 231, 211, 201),
//                 //         fontWeight: FontWeight.w700)),
//                 //  SizedBox(width: 10.0),
//                 Expanded(
//                     flex: 2,
//                     child: FittedBox(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                             Ultils.currencyFormat(
//                                 double.parse(discountedPrice.toString())),
//                             style: MyTextStyle.bold(textColor: kAccentColor)))),
//                 Expanded(
//                     child: FittedBox(
//                         alignment: Alignment.bottomRight,
//                         child: _buildButtonCart(food)))
//               ]);
//   }

//   Widget _buildButtonCart(FoodModel food) {
//     return GestureDetector(
//         onTap: () {
//           Get.toNamed(Routes.order, arguments: {'food': food});
//           // Get.bottomSheet(
//           //     SizedBox(
//           //         height: size.height * 0.75, child: OrderScreen(food: food)),
//           //     ignoreSafeArea: false,
//           //     isScrollControlled: true,
//           //     enableDrag: false,
//           //     useRootNavigator: true);
//         },
//         child: FittedBox(
//             child: Icon(Icons.shopping_cart_outlined,
//                 weight: 10, color: kWhiteColor)));
//   }

//   Widget _buildGridItemFood(BuildContext contextt, List<FoodModel> food) {
//     return Padding(
//         padding: EdgeInsets.symmetric(horizontal: defaultPadding),
//         child: GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisSpacing: defaultPadding,
//             mainAxisSpacing: defaultPadding,
//             crossAxisCount: 2,
//             // scrollDirection: Axis.horizontal,
//             children: food
//                 .map((food) => GestureDetector(
//                     onTap: () {
//                       Get.toNamed(Routes.foodDetail, arguments: {
//                         'food': food,
//                         'heroTag': 'hero-tag-${food.id}+grid'
//                       });
//                     },
//                     child: LayoutBuilder(
//                         builder: (context, constraints) => Container(
//                             width: constraints.constrainHeight(),
//                             decoration: BoxDecoration(
//                                 color: kPrimaryColor,
//                                 borderRadius:
//                                     BorderRadius.circular(defaultBorderRadius),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 1,
//                                       offset: Offset(2, 2),
//                                       color: kWhiteColor.withOpacity(0.08))
//                                 ]),
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: <Widget>[
//                                   Expanded(
//                                       flex: 2,
//                                       child: Stack(children: <Widget>[
//                                         _buildImage(food),
//                                         food.isDiscount == true
//                                             ? _buildPercentDiscount(food)
//                                             : const SizedBox()
//                                       ])),
//                                   Expanded(
//                                       flex: 1,
//                                       child: Padding(
//                                           padding: EdgeInsets.all(
//                                               defaultPadding / 2),
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                     child: _buildTitle(food)),
//                                                 Expanded(
//                                                     child: _buildPriceDiscount(
//                                                         food))
//                                               ])))
//                                 ])))))
//                 .toList()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var foods = <FoodModel>[].obs;
//     // foods.value = list!;

//     // return Obx(() => _buildListItemFood(list!));
//     return _buildGridItemFood(context, list!);
//   }
// }
