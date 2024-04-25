import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_widget.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/features/category/view/screen/create_or_update_category.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../../../common/widget/responsive.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoriesView();
  }
}

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView>
    with AutomaticKeepAliveClientMixin {
  final _key = GlobalKey<ScaffoldState>();
  var _lenght = 0;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    if (!mounted) return;
    context.read<CategoryBloc>().add(CategoriesFetched());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _key,
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody());
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        heroTag: 'addTable',
        tooltip: 'Thêm bàn ăn',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  content: SizedBox(
                      width: 600,
                      child: CreateOrUpdateCategory(
                          lenght: _lenght,
                          categoryModel: CategoryModel(),
                          mode: Mode.create)))).then((result) {
            if (result is bool && result) {
              _getData();
            }
          });
        },
        child: const Icon(Icons.add));
  }

  _buildAppbar() => AppBar(
          title: Text('Danh mục',
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading:
              Responsive.isDesktop(context) ? false : true,
          leading: Responsive.isDesktop(context)
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _key.currentState!.openDrawer()),
          actions: [
            FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          content: SizedBox(
                              width: 600,
                              child: CreateOrUpdateCategory(
                                  lenght: _lenght,
                                  categoryModel: CategoryModel(),
                                  mode: Mode.create)))).then((result) {
                    if (result is bool && result) {
                      _getData();
                    }
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm')),
            const SizedBox(width: 16)
          ]);

  Widget _buildBody() {
    return Builder(builder: (_) {
      var categoryState = context.watch<CategoryBloc>().state;
      return Responsive(
          mobile: _buildMobileWidget(categoryState),
          tablet: _buildMobileWidget(categoryState),
          desktop: _buildWebWidget(categoryState));
    });
  }

  Widget _buildWebWidget(GenericBlocState<CategoryModel> categoryState) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CommonRefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        _getData();
                      },
                      child: switch (categoryState.status) {
                        Status.loading => const LoadingScreen(),
                        Status.empty => const EmptyScreen(),
                        Status.failure =>
                          ErrorScreen(errorMsg: categoryState.error),
                        Status.success => _buildCategories(
                            categoryState.datas ?? <CategoryModel>[])
                      })))
        ]);
  }

  Widget _buildMobileWidget(GenericBlocState<CategoryModel> categoryState) {
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          _getData();
        },
        child: switch (categoryState.status) {
          Status.loading => const LoadingScreen(),
          Status.empty => const EmptyScreen(),
          Status.failure => ErrorScreen(errorMsg: categoryState.error),
          Status.success =>
            _buildCategories(categoryState.datas ?? <CategoryModel>[])
        });
  }

  Widget _buildHeader(CategoryModel categoryModel, int index) => Container(
      height: 40,
      color: context.colorScheme.primary.withOpacity(0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('#${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              const SizedBox(width: 8),
              CommonIconButton(
                  icon: Icons.edit,
                  onTap: () async => _editCategory(categoryModel)),
              const SizedBox(width: 8),
              BlocProvider(
                  create: (context) => CategoryBloc(),
                  child: CommonIconButton(
                      icon: Icons.delete,
                      color: context.colorScheme.errorContainer,
                      onTap: () => _buildDeleteFood(categoryModel)))
            ])
          ])));

  _editCategory(CategoryModel categoryModel) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SizedBox(
                width: 600,
                child: CreateOrUpdateCategory(
                    lenght: _lenght,
                    categoryModel: categoryModel,
                    mode: Mode.update)))).then((result) {
      if (result is bool && result) {
        _getData();
      }
    });
  }

  _buildDeleteFood(CategoryModel categoryModel) async {
    // showCupertinoModalPopup<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SizedBox(
    //           // height: 200,
    //           child: CommonBottomSheet(
    //               title: "Bạn có muốn xóa danh mục này không?",
    //               textConfirm: 'Xóa',
    //               textCancel: "Hủy",
    //               textConfirmColor: context.colorScheme.errorContainer,
    //               onConfirm: () => _handleDeleteFood(categoryModel)));
    //     });

    await AppAlerts.warningDialog(context,
        title: 'Xóa "${categoryModel.name}"?',
        desc: 'Kiểm tra kĩ trước khi xóa!',
        textCancel: 'Hủy',
        textOk: 'Xóa',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () => _handleDeleteFood(categoryModel));
  }

  void _handleDeleteFood(CategoryModel categoryModel) {
    // context.pop();
    context
        .read<CategoryBloc>()
        .add(CategoryDeleted(categoryModel: categoryModel));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<CategoryBloc, GenericBlocState>(
            builder: (context, state) => switch (state.status) {
                  Status.empty => const SizedBox(),
                  Status.loading => const ProgressDialog(
                      isProgressed: true, descriptrion: 'Đang xóa'),
                  Status.failure =>
                    ErrorWidgetCustom(errorMessage: state.error ?? ''),
                  Status.success => ProgressDialog(
                      descriptrion: 'Xóa thành công',
                      onPressed: () {
                        _getData();
                        pop(context, 1);
                      },
                      isProgressed: false)
                }));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildCategories(List<CategoryModel> categories) {
    var modifiableList = List.from(categories);
    modifiableList.sort((a, b) => a.sort!.compareTo(b.sort!));
    _lenght = modifiableList.length;
    return GridView.builder(
        shrinkWrap: true,
        itemCount: modifiableList.length,
        itemBuilder: (context, index) =>
            _buildCategory(modifiableList[index], index),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: countGridView(context),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16));
  }

  Widget _buildCategory(CategoryModel categoryModel, int index) {
    return Card(
        elevation: 10,
        child: Column(children: [
          _buildHeader(categoryModel, index),
          Expanded(child: _buildItemBody(categoryModel))
        ]));
  }

  Widget _buildItemBody(CategoryModel categoryModel) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(child: _buildImage(categoryModel)),
      Expanded(child: _buildInfo(categoryModel))
    ]);
  }

  Widget _buildImage(CategoryModel categoryModel) => Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: context.colorScheme.background, shape: BoxShape.circle),
      // height: 60,
      // width: 60,
      child: Image.network(categoryModel.image ?? noImage,
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null ? child : const LoadingScreen()));

  Widget _buildInfo(CategoryModel categoryModel) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(categoryModel.name ?? '',
                        textAlign: TextAlign.center))),
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                    child: Text(
                        categoryModel.description!.isEmpty
                            ? '_'
                            : categoryModel.description!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: context.textStyleSmall!
                            .copyWith(color: Colors.white.withOpacity(0.5)))))
          ]);

  _buildFloadtingButton() => FloatingActionButton(
      backgroundColor: context.colorScheme.secondary,
      onPressed: () async {
        // var result = await context.push(RouteName.createOrUpdateCategory,
        //     extra: {'categoryModel': CategoryModel(), 'mode': Mode.create});

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                content: SizedBox(
                    width: 600,
                    child: CreateOrUpdateCategory(
                        lenght: _lenght,
                        categoryModel: CategoryModel(),
                        mode: Mode.create)))).then((result) {
          if (result is bool && result) {
            _getData();
          }
        });
      },
      child: const Icon(Icons.add));
}
