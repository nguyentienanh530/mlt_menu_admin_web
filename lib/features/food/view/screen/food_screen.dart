import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_admin_web/features/search_food/cubit/text_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin_web/config/router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../data/model/food_model.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/list_food_dont_show.dart';
import '../widgets/list_food_is_show.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FoodScreen>
    with AutomaticKeepAliveClientMixin {
  var _isSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _getData() {
    if (!mounted) return;
    // context.read<FoodBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => FoodBloc(),
        child: Scaffold(
            floatingActionButton: _buildFloatingActionButton(),
            appBar: _buildAppbar(context),
            body: BlocBuilder<TextSearchCubit, String>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return Column(children: [
                    DefaultTabController(
                        length: 2,
                        child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: context.colorScheme.secondary,
                            onTap: (value) => _pageController.jumpToPage(value),
                            tabs: const [
                              Tab(text: 'Đang hiển thị'),
                              Tab(text: 'Đang ẩn')
                            ])),
                    Expanded(
                        child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                          ListFoodIsShow(textSearch: state),
                          ListFoodDontShow(textSearch: state)
                        ]))
                  ]);
                })));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        heroTag: 'addFood',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () async {
          var result = await context.push(RouteName.createOrUpdateFood,
              extra: {'mode': Mode.create, 'food': Food()});
          if (result is bool && result) {}
        },
        child: const Icon(Icons.add));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: _isSearch
            ? _buildSearch(context)
                .animate()
                .slideX(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)
            : AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                child: Text('Danh sách món', style: context.titleStyleMedium)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearch = !_isSearch;
                });
              },
              icon: Icon(
                  !_isSearch ? Icons.search : Icons.highlight_remove_sharp))
        ]);
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
  }
}
