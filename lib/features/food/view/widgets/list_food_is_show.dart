import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/common_text_field.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/food/view/screen/create_or_update_food_screen.dart';
import 'package:mlt_menu_admin_web/features/food/view/screen/food_detail_screen.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../core/utils/utils.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../../home/view/screen/home_screen.dart';
import '../../bloc/food_bloc.dart';
import '../../data/model/food_model.dart';
import 'item_food.dart';

class ListFoodIsShow extends StatelessWidget {
  const ListFoodIsShow({super.key, required this.isShowFood});
  final bool isShowFood;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
            create: (context) => FoodBloc(),
            child: ListFoodIsShowView(isShowFood: isShowFood))
        .animate()
        .slideX(
            begin: -0.1, end: 0, curve: Curves.easeInOutCubic, duration: 500.ms)
        .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
  }
}

class ListFoodIsShowView extends StatefulWidget {
  const ListFoodIsShowView({super.key, required this.isShowFood});
  final bool isShowFood;
  @override
  State<ListFoodIsShowView> createState() => _ListFoodIsShowViewState();
}

class _ListFoodIsShowViewState extends State<ListFoodIsShowView>
    with AutomaticKeepAliveClientMixin {
  var _searchList = <Food>[];
  var _list = <Food>[];
  final _searchCtrl = TextEditingController();
  final _searchText = ValueNotifier('');
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
    context.read<FoodBloc>().add(FoodsFetched(isShowFood: widget.isShowFood));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _key,
        drawer: SideMenu(
            scafoldKey: _key,
            onPageSelected: (page) {
              _key.currentState!.closeDrawer();
              context.read<PageHomeCubit>().pageChanged(page);
            }),
        appBar: _buildAppbar(),
        body: SafeArea(child: Builder(builder: (context) {
          var foodIsShow = context.watch<FoodBloc>().state;
          return (switch (foodIsShow.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const EmptyScreen(),
            Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
            Status.success => Column(children: [
                _buildSearch(),
                Expanded(
                    child: CommonRefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          _getData();
                        },
                        child: _buildWidget(foodIsShow.datas ?? <Food>[])))
              ])
          });
        })));
  }

  _buildAppbar() => AppBar(
      centerTitle: true,
      automaticallyImplyLeading: Responsive.isDesktop(context) ? false : true,
      actions: [
        FilledButton(
            onPressed: () {
              _showDialogCreateOrUpdateFood();
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(context.colorScheme.secondary)),
            child: const FittedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.add),
                  FittedBox(child: Text('Thêm Mới'))
                ])))
      ],
      title: Text('Danh sách món đang hiện thị',
          style:
              context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)));

  _buildSearch() => CommonTextField(
      controller: _searchCtrl,
      onChanged: (value) {
        _searchText.value = value;
      },
      prefixIcon: const Icon(Icons.search),
      hintText: 'Tìm kiếm món ăn');

  Widget _buildWidget(List<Food> listFood) {
    _list = listFood;

    return ValueListenableBuilder(
        valueListenable: _searchText,
        builder: (context, value, child) {
          _buildSreachList(value);
          return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _searchList.length,
                  itemBuilder: (context, i) {
                    return ItemFood(
                        onTapEditFood: () async =>
                            await _goToEditFood(context, _searchList[i]),
                        onTapDeleteFood: () =>
                            _buildDeleteFood(context, _searchList[i]),
                        index: i,
                        food: _searchList[i],
                        onTapView: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                  child: SizedBox(
                                      width: 600,
                                      child: FoodDetailScreen(
                                          food: _searchList[i]))));
                        });
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      crossAxisCount: countGridView(context))));
        });
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

  _goToEditFood(BuildContext context, Food food) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SizedBox(
                      width: 600,
                      child: CreateOrUpdateFoodScreen(
                          food: food, mode: Mode.update))));
        }).then((value) async {
      if (value is bool && value) {
        _getData();
      }
    });
  }

  _buildDeleteFood(BuildContext context, Food food) {
    AppAlerts.warningDialog(context,
        title: "Bạn có muốn xóa ${food.name} không?",
        textOk: 'Xóa',
        textCancel: "Hủy",
        btnOkOnPress: () => _handleDeleteFood(context, food));
  }

  void _handleDeleteFood(BuildContext context, Food food) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
              create: (context) => FoodBloc()..add(DeleteFood(foodID: food.id)),
              child: Builder(builder: (context) {
                var state = context.watch<FoodBloc>().state;
                return switch (state.status) {
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
                        pop(context, 1);
                        _getData();
                      },
                      isProgressed: false)
                };
              }));
        });
  }

  @override
  bool get wantKeepAlive => true;

  void _showDialogCreateOrUpdateFood() {
    showDialog(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: SizedBox(
                  width: 600,
                  child: CreateOrUpdateFoodScreen(
                      food: Food(), mode: Mode.create)));
        }).then((value) async {
      if (value is bool && value) {
        _getData();
      }
    });
  }
}
