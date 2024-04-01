import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/food_model.dart';
import '../../../../core/utils/utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, this.food});
  final Food? food;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodBloc(),
      child: Scaffold(
          appBar: _buildAppbar(context), body: FoodDetailView(food: food!)),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(AppString.titleFoodDetail, style: context.titleStyleMedium),
        centerTitle: true);
  }
}

class FoodDetailView extends StatefulWidget {
  const FoodDetailView({super.key, required this.food});
  final Food food;

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context, widget.food);
  }

  Widget _buildBody(BuildContext context, Food food) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageFood(food: food),
              _buildTitle(context, food),
              _buildPrice(context, food),
              _buildStatus(context, food),
              _buildDescription(context, food),
              food.photoGallery.isNotEmpty
                  ? _Gallery(food: food)
                  : const SizedBox()
            ]
                .animate(interval: 50.ms)
                .slideX(
                    begin: -0.1,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)));
  }

  Widget _buildDescription(BuildContext context, Food food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mô tả', style: context.titleStyleMedium),
          ReadMoreText(food.description,
              trimLines: 8,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Xem thêm...',
              trimExpandedText: 'ẩn bớt',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
              lessStyle: context.textStyleSmall!
                  .copyWith(color: context.colorScheme.secondary),
              moreStyle: context.textStyleSmall!
                  .copyWith(color: context.colorScheme.secondary))
        ]));
  }

  Widget _buildTitle(BuildContext context, Food food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Text(food.name, style: context.titleStyleMedium));
  }

  Widget _buildPrice(BuildContext context, Food food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Ultils.currencyFormat(double.parse(food.price.toString())),
              style: TextStyle(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold))
        ]));
  }

  Widget _buildStatus(BuildContext context, Food food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Row(children: [
          Text('Trạng thái: ', style: context.titleStyleMedium),
          Text(Ultils.foodStatus(food.isShowFood),
              style: TextStyle(
                  color: food.isShowFood
                      ? context.colorScheme.secondary
                      : context.colorScheme.error))
        ]));
  }
}

class _ImageFood extends StatelessWidget {
  const _ImageFood({required this.food});
  final Food food;
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'hero-tag-${food.id}-search',
        child: Material(
            child: Container(
                height: context.sizeDevice.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: context.colorScheme.background,
                    // borderRadius:
                    //     BorderRadius.vertical(bottom: Radius.circular(22 )),
                    image: DecorationImage(
                        image: NetworkImage(
                            food.image == "" ? noImage : food.image),
                        fit: BoxFit.cover)),
                alignment: Alignment.topCenter)));
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.food});
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: Text('Thư viện ảnh', style: context.titleStyleMedium)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: _buildImage(
                    context,
                    (food.photoGallery.length > 1)
                        ? (food.photoGallery[0].isEmpty
                            ? noImage
                            : food.photoGallery[0])
                        : noImage)),
            SizedBox(width: defaultPadding / 2),
            Expanded(
                child: _buildImage(
                    context,
                    (food.photoGallery.length > 1)
                        ? (food.photoGallery[1].isEmpty
                            ? noImage
                            : food.photoGallery[1])
                        : noImage)),
            SizedBox(width: defaultPadding / 2),
            Expanded(
                child: _buildImage(
                    context,
                    (food.photoGallery.length > 2)
                        ? (food.photoGallery[2].isEmpty
                            ? noImage
                            : food.photoGallery[2])
                        : noImage))
          ]))
    ]);
  }

  Widget _buildImage(BuildContext context, String item) {
    return InkWell(
        onTap: () {
          viewImage(context, item);
        },
        child: Container(
            height: context.sizeDevice.height * 0.15,
            width: context.sizeDevice.width / 3.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(item), fit: BoxFit.cover),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 2.0)
                ])));
  }

  viewImage(BuildContext context, String item) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Material(
              clipBehavior: Clip.antiAlias,
              elevation: 18.0,
              color: context.colorScheme.background,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        height: context.sizeDevice.width * 0.9,
                        width: context.sizeDevice.width * 0.9,
                        decoration: BoxDecoration(
                            color: kRedColor,
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: NetworkImage(item)))),
                    IconButton(
                        iconSize: 30,
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.highlight_remove_sharp),
                        color: context.colorScheme.secondaryContainer)
                  ])));
        },
        transitionDuration: const Duration(milliseconds: 500)));
  }
}
