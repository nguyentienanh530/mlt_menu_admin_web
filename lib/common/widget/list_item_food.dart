// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// // import 'package:get/get.dart';

// // import '../pages/order_page/order_page.dart';
// import '../../../../app_export.dart';

// class ListItemFood extends StatelessWidget {
//   final List<FoodModel>? list;

//   // final getContext = Get.context;

//   ListItemFood({super.key, required this.list});
//   Widget _buildImage(FoodModel food) {
//     return Hero(
//         tag: 'hero-tag-${food.id}+list',
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
//     return isPhone
//         ? Container(
//             height: 30,
//             width: 50,
//             decoration: BoxDecoration(
//                 color: kRedColor,
//                 borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(defaultBorderRadius),
//                     topLeft: Radius.circular(defaultBorderRadius))),
//             child: Center(
//                 child: Text("${food.discount}%",
//                     style: MyTextStyle.normal(fontSize: kTextSizeSmall - 2))))
//         : Container(
//             height: 50,
//             width: 70,
//             decoration: BoxDecoration(
//                 color: kRedColor,
//                 borderRadius: const BorderRadius.only(
//                     bottomRight: Radius.circular(20.0),
//                     topLeft: Radius.circular(15.0))),
//             child: Center(
//                 child: Text("${food.discount}%",
//                     style: MyTextStyle.normal(fontSize: kTextSizeLarge - 2))));
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
//           //         height: size.height * 0.75, child: OrderPage(food: food)),
//           //     ignoreSafeArea: false,
//           //     isScrollControlled: true,
//           //     enableDrag: false,
//           //     useRootNavigator: true);
//         },
//         child: FittedBox(
//             child: Icon(Icons.shopping_cart_outlined,
//                 weight: 10, color: kWhiteColor)));
//   }

//   Widget _buildListItemFood(List<FoodModel> food) {
//     return ListView(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         children: food
//             .map((food) => GestureDetector(
//                 onTap: () {
//                   // FirebaseFirestore.instance
//                   //     .collection('food')
//                   //     .doc(list?[i].id)
//                   //     .update({'count': FieldValue.increment(1)});

//                   Get.toNamed(Routes.foodDetail, arguments: {
//                     'food': food,
//                     'heroTag': 'hero-tag-${food.id}+list'
//                   });
//                 },
//                 child: LayoutBuilder(
//                     builder: (context, constraints) => Container(
//                         width: constraints.constrainHeight(),
//                         margin:
//                             EdgeInsets.only(bottom: 2, left: defaultPadding),
//                         decoration: BoxDecoration(
//                             color: kPrimaryColor,
//                             borderRadius:
//                                 BorderRadius.circular(defaultBorderRadius),
//                             boxShadow: [
//                               BoxShadow(
//                                   blurRadius: 1,
//                                   offset: Offset(2, 2),
//                                   color: kWhiteColor.withOpacity(0.08))
//                             ]),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: <Widget>[
//                               Expanded(
//                                   flex: 2,
//                                   child: Stack(children: <Widget>[
//                                     _buildImage(food),
//                                     food.isDiscount == true
//                                         ? _buildPercentDiscount(food)
//                                         : const SizedBox()
//                                   ])),
//                               Expanded(
//                                   flex: 1,
//                                   child: Padding(
//                                       padding:
//                                           EdgeInsets.all(defaultPadding / 2),
//                                       child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(child: _buildTitle(food)),
//                                             Expanded(
//                                                 child:
//                                                     _buildPriceDiscount(food))
//                                           ])))
//                             ])))))
//             .toList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildListItemFood(list!);
//   }
// }
