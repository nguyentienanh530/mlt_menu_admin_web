import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';
import '../../../../common/widget/responsive.dart';
import '../../../../config/config.dart';
import '../../bloc/food_bloc.dart';
import '../../data/model/food_model.dart';
import '../screen/create_or_update_food_screen.dart';
import 'item_food.dart';

class ListFoodDontShow extends StatelessWidget {
  const ListFoodDontShow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
            create: (context) => FoodBloc(), child: const ListFoodIsShowView())
        .animate()
        .slideX(
            begin: -0.1, end: 0, curve: Curves.easeInOutCubic, duration: 500.ms)
        .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
  }
}

class ListFoodIsShowView extends StatefulWidget {
  const ListFoodIsShowView({super.key});

  @override
  State<ListFoodIsShowView> createState() => _ListFoodIsShowViewState();
}

class _ListFoodIsShowViewState extends State<ListFoodIsShowView>
    with AutomaticKeepAliveClientMixin {
  var _searchList = <Food>[];
  var _list = <Food>[];
  final _searchCtrl = TextEditingController();
  final _searchText = ValueNotifier('');

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // _ListFoodIsShowViewState() {
  //   setState(() {});
  // }

  void _getData() {
    if (!mounted) return;
    context.read<FoodBloc>().add(const FoodsFetched(isShowFood: false));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(builder: (context) {
      var foodIsShow = context.watch<FoodBloc>().state;
      return CommonRefreshIndicator(
          child: (switch (foodIsShow.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const EmptyScreen(),
            Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
            Status.success => _buildWidget(foodIsShow.datas ?? <Food>[])
          }),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
            _getData();
          });
    });
  }

  _buildHeaderMobile() => Row(children: [
        // Expanded(
        //   flex: 2,
        //   child: Text('Danh Sách Món Ăn',
        //       style: context.titleStyleMedium!
        //           .copyWith(fontWeight: FontWeight.bold)),
        // ),
        Expanded(
            flex: 2,
            child: CommonTextField(
                controller: _searchCtrl,
                onChanged: (value) {
                  _searchText.value = value;
                },
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm món ăn')),
        Expanded(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SizedBox(
                                      width: 600,
                                      child: CreateOrUpdateFoodScreen(
                                          food: Food(), mode: Mode.create),
                                    )));
                          });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            context.colorScheme.secondary)),
                    child: const FittedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.add),
                          FittedBox(child: Text('Thêm Mới'))
                        ])))))
      ]);

  _buildHeaderWeb() => Row(children: [
        Expanded(
            flex: 4,
            child: Text('Danh Sách Món Ăn',
                style: context.titleStyleLarge!
                    .copyWith(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 4,
            child: CommonTextField(
                controller: _searchCtrl,
                onChanged: (value) {
                  _searchText.value = value;
                },
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm món ăn')),
        Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SizedBox(
                                      width: 600,
                                      child: CreateOrUpdateFoodScreen(
                                          food: Food(), mode: Mode.create),
                                    )));
                          });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            context.colorScheme.secondary)),
                    child: const FittedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.add),
                          FittedBox(child: Text('Thêm Mới'))
                        ])))))
      ]);

  Widget _buildWidget(List<Food> listFood) {
    _list = listFood;

    return Scaffold(
      body: Column(children: [
        Responsive(
            mobile: _buildHeaderMobile(),
            tablet: _buildHeaderMobile(),
            desktop: _buildHeaderWeb()),
        // const SizedBox(height: 16),
        Expanded(
            child: ValueListenableBuilder(
                valueListenable: _searchText,
                builder: (context, value, child) {
                  _buildSreachList(value);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _searchList.length,
                        itemBuilder: (context, i) {
                          return ItemFood(
                              onTapEditFood: () async =>
                                  await _goToEditFood(context, _searchList[i]),
                              onTapDeleteFood: () =>
                                  _buildDeleteFood(context, _searchList[i]),
                              index: i,
                              food: _searchList[i],
                              onTapView: () => context.push(
                                  RouteName.foodDetail,
                                  extra: _searchList[i]));
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            crossAxisCount: _handleCountGridView())),
                  );
                }))
      ]),
    );
  }

  _buildSreachList(String textSearch) {
    if (textSearch.isEmpty) {
      return _searchList = _list;
    } else {
      _searchList = _list
          .where((element) =>
              element.name
                  .toString()
                  .toLowerCase()
                  .contains(textSearch.toLowerCase()) ||
              TiengViet.parse(element.name.toString().toLowerCase())
                  .contains(textSearch.toLowerCase()))
          .toList();

      return _searchList;
    }
  }

  int _handleCountGridView() {
    if (Responsive.isMobile(context)) {
      return 2;
    }
    if (Responsive.isTablet(context)) {
      return 4;
    } else {
      return 6;
    }
  }

  _goToEditFood(BuildContext context, Food food) async =>
      await context.push(RouteName.createOrUpdateFood,
          extra: {'food': food, 'mode': Mode.update}).then((value) {
        if (value is bool && value == true) {
          context.read<FoodBloc>().add(const FoodsFetched(isShowFood: true));
        }
      });

  _buildDeleteFood(BuildContext context, Food food) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              // height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa món ăn này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
                  onConfirm: () => _handleDeleteFood(context, food)));
        });
  }

  void _handleDeleteFood(BuildContext context, Food food) {
    context.read<FoodBloc>().add(DeleteFood(foodID: food.id));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) => switch (state.status) {
                  Status.empty => const SizedBox(),
                  Status.loading => const ProgressDialog(
                      isProgressed: true, descriptrion: 'Đang xóa'),
                  Status.failure => RetryDialog(
                      title: state.error ?? "Lỗi",
                      onRetryPressed: () => context
                          .read<FoodBloc>()
                          .add(DeleteFood(foodID: food.id))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Xóa thành công',
                      onPressed: () {
                        FToast()
                          ..init(context)
                          ..showToast(
                              child: AppAlerts.successToast(
                                  msg: 'Xóa thành công!'));
                        pop(context, 2);
                        _getData();
                      },
                      isProgressed: false)
                }));
  }

  @override
  bool get wantKeepAlive => true;
}
