import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/features/category/view/screen/create_or_update_category.dart';
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
    return CustomScrollView(slivers: [
      SliverAppBar(
          title: Text('Danh mục',
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
          pinned: true,
          stretch: true,
          automaticallyImplyLeading:
              Responsive.isDesktop(context) ? false : true,
          actions: [
            FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          content: SizedBox(
                              width: 600,
                              child: CreateOrUpdateCategory(
                                  categoryModel: CategoryModel(),
                                  mode: Mode.create)))).then((result) {
                    if (result is bool && result) {
                      _getData();
                    }
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm'))
          ]),
      SliverToBoxAdapter(child: _buildBody())
    ]);
  }

  Widget _buildBody() {
    return Builder(builder: (_) {
      var categoryState = context.watch<CategoryBloc>().state;
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
                    onTap: () => _buildDeleteFood(categoryModel)),
              )
            ])
          ])));

  _editCategory(CategoryModel categoryModel) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SizedBox(
                width: 600,
                child: CreateOrUpdateCategory(
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
    return GridView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) =>
            _buildCategory(categories[index], index),
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
      Expanded(flex: 2, child: _buildImage(categoryModel)),
      Expanded(child: _buildInfo(categoryModel))
    ]);
  }

  _buildAppbar() => AppBar(
      title: Text('Danh mục', style: context.titleStyleMedium),
      centerTitle: true);

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
                    child: Text(categoryModel.name ?? '',
                        textAlign: TextAlign.center))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: Text('Mô tả: ',
                                  style: context.textStyleSmall!.copyWith(
                                      color: Colors.white.withOpacity(0.5)))),
                          Expanded(
                              flex: 5,
                              child: Text(
                                  categoryModel.description!.isEmpty
                                      ? '_'
                                      : categoryModel.description!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: context.textStyleSmall!.copyWith(
                                      color: Colors.white.withOpacity(0.5))))
                        ])))
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
                        categoryModel: CategoryModel(),
                        mode: Mode.create)))).then((result) {
          if (result is bool && result) {
            _getData();
          }
        });
      },
      child: const Icon(Icons.add));
}
