import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/config/router.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/data/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/common_icon_button.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CategoriesView());
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
    return Scaffold(
        floatingActionButton: _buildFloadtingButton(),
        appBar: _buildAppbar(),
        body: SafeArea(child: _buildBody()));
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
                  onTap: () async {
                    var result = await context
                        .push(RouteName.createOrUpdateCategory, extra: {
                      'categoryModel': categoryModel,
                      'mode': Mode.update
                    });
                    if (result is bool && result) {
                      _getData();
                    }
                  }),
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

  _buildDeleteFood(CategoryModel categoryModel) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              // height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa danh mục này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
                  onConfirm: () => _handleDeleteFood(categoryModel)));
        });
  }

  void _handleDeleteFood(CategoryModel categoryModel) {
    context.pop();
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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) =>
                _buildCategory(categories[index], index)));
  }

  Widget _buildCategory(CategoryModel categoryModel, int index) {
    return Card(
        elevation: 10,
        child: Column(children: [
          _buildHeader(categoryModel, index),
          _buildItemBody(categoryModel)
        ]));
  }

  _buildItemBody(CategoryModel categoryModel) {
    return Row(
        children: [_buildImage(categoryModel), _buildInfo(categoryModel)]);
  }

  _buildAppbar() => AppBar(
      title: Text('Danh mục', style: context.titleStyleMedium),
      centerTitle: true);

  _buildImage(CategoryModel categoryModel) => Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: context.colorScheme.background, shape: BoxShape.circle),
      height: 60,
      width: 60,
      child: Image.network(categoryModel.image ?? noImage,
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null ? child : const LoadingScreen()));

  _buildInfo(CategoryModel categoryModel) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryModel.name ?? ''),
            const SizedBox(height: 8),
            Row(children: [
              Text('Mô tả: ',
                  style: context.textStyleSmall!
                      .copyWith(color: Colors.white.withOpacity(0.5))),
              SizedBox(
                  width: context.sizeDevice.width -
                      context.sizeDevice.width * 0.35,
                  child: Text(
                      categoryModel.description!.isEmpty
                          ? '_'
                          : categoryModel.description!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.textStyleSmall!
                          .copyWith(color: Colors.white.withOpacity(0.5))))
            ])
          ]);

  _buildFloadtingButton() => FloatingActionButton(
      backgroundColor: context.colorScheme.secondary,
      onPressed: () async {
        var result = await context.push(RouteName.createOrUpdateCategory,
            extra: {'categoryModel': CategoryModel(), 'mode': Mode.create});
        if (result is bool && result) {
          _getData();
        }
      },
      child: const Icon(Icons.add));
}
