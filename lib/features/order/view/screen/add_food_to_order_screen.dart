import 'package:mlt_menu_admin_web/features/order/data/model/food_dto.dart';
import 'package:mlt_menu_admin_web/features/search_food/cubit/text_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../food/data/model/food_model.dart';
import '../../../../core/utils/utils.dart';

class AddFoodToOrderScreen extends StatelessWidget {
  const AddFoodToOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TextSearchCubit(),
        child: Column(
            children: [_buildAppbar(context), Expanded(child: AddFoodView())]));
  }
}

_buildAppbar(BuildContext context) {
  return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text('Danh sách món ăn', style: context.titleStyleMedium),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_remove_rounded))
      ]);
}

class AddFoodView extends StatelessWidget {
  AddFoodView({super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding),
          child: _buildSearch(context)),
      Expanded(child:
          BlocBuilder<TextSearchCubit, String>(builder: (context, state) {
        return AfterSearchUI(text: state);
      }))
    ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 500.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms));
  }

  Widget _buildSearch(BuildContext context) {
    return CommonTextField(
        controller: _searchController,
        onChanged: (value) =>
            context.read<TextSearchCubit>().textChanged(value),
        hintText: "Tìm kiếm",
        suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<TextSearchCubit>().clear();
              _searchController.clear();
            }),
        prefixIcon: const Icon(Icons.search));

    // TextFormField(
    //     // controller: controller,
    //     onChanged: (value) {
    //       // _.textValue.value = value;

    //       // context.read<SearchBloc>().setSearchText(value);
    //       // context.read<SearchBloc>().getData();
    //     },
    //     style: context.textStyleSmall,
    //     decoration: InputDecoration(
    //         border: InputBorder.none,
    //         prefixIcon: const Icon(Icons.search),
    //         hintText: "Tìm kiếm",
    //         hintStyle: context.textStyleSmall,
    //         suffixIcon: IconButton(
    //             icon: const Icon(Icons.close),
    //             onPressed: () {
    //               // _.textValue.value = '';
    //               // controller.clear();

    //               // searchCtrl.saerchInitialize();
    //             })),
    //     textInputAction: TextInputAction.search,
    //     onFieldSubmitted: (value) {
    //       if (value == '') {
    //         // Get.snackbar('Thông báo', 'trống').show();
    //       } else {
    //         // searchCtrl.setSearchText(value);
    //         // context
    //         //     .read<SearchBloc>()
    //         //     .addToSearchList(value);
    //         // context.read<SearchBloc>().getData();
    //       }
    //     });
  }
}

class AfterSearchUI extends StatelessWidget {
  final String? text;

  const AfterSearchUI({super.key, this.text});
  @override
  Widget build(BuildContext context) {
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsFetched(isShowFood: true)),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => loadingOrInitState,
            Status.empty => const EmptyScreen(),
            Status.failure => Center(child: Text(state.error!)),
            Status.success => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.datas!.length,
                itemBuilder: (context, i) {
                  if (state.datas![i].name
                          .toString()
                          .toLowerCase()
                          .contains(text!.toLowerCase()) ||
                      TiengViet.parse(
                              state.datas![i].name.toString().toLowerCase())
                          .contains(text!.toLowerCase())) {
                    return _buildItemSearch(context, state.datas![i]);
                  }
                  return const SizedBox();
                })
          });
        }));
  }

  Widget _buildItemSearch(BuildContext context, Food food) {
    return InkWell(
        onTap: () {
          var foodDto = FoodDto(
              foodID: food.id,
              quantity: 1,
              note: '',
              discount: 0,
              foodImage: food.image,
              foodName: food.name,
              foodPrice: food.price,
              isDiscount: food.isDiscount,
              totalPrice: Ultils.foodPrice(
                  isDiscount: food.isDiscount,
                  foodPrice: food.price,
                  discount: food.discount));
          context.pop<FoodDto>(foodDto);
        },
        child: Card(
            borderOnForeground: false,
            child: SizedBox(
                height: 60,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImage(food),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTitle(context, food),
                            // _buildCategory(context, food),
                            _buildPrice(context, food)
                          ])
                    ]
                        .animate(interval: 50.ms)
                        .slideX(
                            begin: -0.1,
                            end: 0,
                            curve: Curves.easeInOutCubic,
                            duration: 500.ms)
                        .fadeIn(
                            curve: Curves.easeInOutCubic, duration: 500.ms)))));
  }

  Widget _buildImage(Food food) {
    return Material(
        color: Colors.transparent,
        child: Container(
            margin: EdgeInsets.all(defaultPadding / 3),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
                image: DecorationImage(
                    image:
                        NetworkImage(food.image == "" ? noImage : food.image),
                    fit: BoxFit.cover))));
  }

  Widget _buildCategory(BuildContext context, Food food) {
    return FittedBox(child: Text('asdasdasd', style: context.textStyleSmall!));
  }

  Widget _buildTitle(BuildContext context, Food food) {
    return FittedBox(child: Text(food.name));
  }

  Widget _buildPrice(BuildContext context, Food food) {
    double discountAmount = (food.price * food.discount.toDouble()) / 100;
    double discountedPrice = food.price - discountAmount;
    return food.isDiscount == false
        ? Text(Ultils.currencyFormat(double.parse(food.price.toString())),
            style: TextStyle(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.bold))
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text(Ultils.currencyFormat(double.parse(food.price.toString())),
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
            ])
          ]);
  }

  Widget _buildPercentDiscount(Food food) {
    return Container(
        height: 80,
        width: 80,
        // decoration: BoxDecoration(color: redColor),
        child: Center(child: CommonLineText(value: "${food.discount}%")

            // Text("${food.discount}%",
            //     style: TextStyle(
            //         fontSize: 16,
            //         color: textColor,
            //         fontFamily: Constant.font,
            //         fontWeight: FontWeight.w600)))
            ));
  }
}
