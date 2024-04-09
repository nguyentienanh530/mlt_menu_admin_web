import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/core/utils/extensions.dart';
import 'package:mlt_menu_admin_web/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/data/model/category_model.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc()..add(CategoriesFetched()),
      child: Builder(builder: (context) {
        var state = context.watch<CategoryBloc>().state;
        return switch (state.status) {
          Status.loading => const LoadingScreen(),
          Status.empty => const EmptyWidget(),
          Status.failure => ErrorWidgetCustom(errorMessage: state.error ?? ''),
          Status.success => ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: state.datas!.length >= 10 ? 10 : state.datas!.length,
              itemBuilder: (context, index) => _buildCategory(
                  context, state.datas?[index] ?? CategoryModel()))
        };
      }),
    );
  }

  Widget _buildCategory(BuildContext context, CategoryModel categoryModel) {
    return Card(
        elevation: 10,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: context.sizeDevice.height * 0.15,
                height: context.sizeDevice.height * 0.15,
                child: Column(children: [
                  Expanded(
                      flex: 3,
                      child: Image.network(categoryModel.image ?? '',
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress != null
                                  ? const LoadingScreen()
                                  : child)),
                  const SizedBox(height: 8),
                  Expanded(child: Text(categoryModel.name ?? ''))
                ]))));
  }
}
