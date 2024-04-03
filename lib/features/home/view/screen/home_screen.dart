import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/config/router.dart';
import 'package:mlt_menu_admin_web/features/auth/bloc/auth_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/view/screen/categories_screen.dart';
import 'package:mlt_menu_admin_web/features/food/view/widgets/list_food_is_show.dart';
import 'package:mlt_menu_admin_web/features/home/cubit/home_cubit.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_screen.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/profile_screen.dart';
import 'package:mlt_menu_admin_web/features/table/view/screen/table_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../common/widget/responsive.dart';
import '../../../food/view/widgets/list_food_dont_show.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/print_data_source/print_data_source.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(), child: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController controller = PageController();

  @override
  void initState() {
    _updateToken();
    getUserData();
    getIsUsePrint();
    _handleGetPrint();

    super.initState();
  }

  void _handleGetPrint() async {
    var print = await PrintDataSource.getPrint();
    if (!mounted) return;
    if (print != null) {
      context.read<PrintCubit>().onPrintChanged(print);
    }
  }

  void getIsUsePrint() async {
    var isUsePrint = await PrintDataSource.getIsUsePrint() ?? false;
    if (!mounted) return;
    context.read<IsUsePrintCubit>().onUsePrintChanged(isUsePrint);
  }

  void getUserData() {
    if (!mounted) return;
    context.read<UserBloc>().add(UserFecthed(userID: _getUserID()));
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  _updateToken() async {
    var token = await getToken();

    UserRepository(firebaseFirestore: FirebaseFirestore.instance)
        .updateAdminToken(userID: _getUserID(), token: token ?? '');
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  // _handelUpdate(String userID, String token) {
  //   context.read<UserBloc>().add(UpdateToken(userID: userID, token: token));
  // }

  final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    const OrderScreen(),
    // const FoodScreen(),
    const TableScreen(),
    const CategoriesScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserBloc>().state;
    var currentPageState = context.watch<PageHomeCubit>().state;
    switch (userState.status) {
      case Status.loading:
        return Scaffold(
            body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: _widgetOptions));
      case Status.empty:
        return const EmptyScreen();
      case Status.failure:
        return ErrorScreen(errorMsg: userState.error ?? '');
      case Status.success:
        if (userState.data?.role == 'admin') {
          _updateToken();
          return Scaffold(
              body: SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                if (Responsive.isDesktop(context))
                  Expanded(child: SideMenu(onPageSelected: (page) {
                    context.read<PageHomeCubit>().pageChanged(page);
                  })),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Expanded(flex: 5, child: currentPageState)
                        ])))
              ]))

              // PageView(
              //     physics: const NeverScrollableScrollPhysics(),
              //     controller: controller,
              //     children: _widgetOptions)
              );
        }
        return Center(
            child: Card(
                margin: const EdgeInsets.all(16),
                color: context.colorScheme.error.withOpacity(0.2),
                child: Container(
                    height: context.sizeDevice.width * 0.8,
                    width: context.sizeDevice.width * 0.8,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outlined,
                              color: context.colorScheme.error, size: 50.0),
                          const SizedBox(height: 10.0),
                          Text('Thông báo',
                              style: context.titleStyleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10.0),
                          const Text("Tài khoản không có quyền sử dụng!",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 30),
                          FilledButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthLogoutRequested());
                                context.go(RouteName.login);
                              },
                              child: const Text('Quay lại đăng nhập',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))
                        ]))));

      default:
        return const LoadingScreen();
    }
  }
}

class SideMenu extends StatelessWidget {
  final Function(Widget) onPageSelected;
  const SideMenu({
    super.key,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      DrawerHeader(child: Image.asset("assets/image/logo.png")),
      DrawerListTile(
          title: "Dashboard",
          svgSrc: "assets/icon/dashboard.svg",
          onTap: () => onPageSelected(const DashboardScreen())),
      DrawerExpansionTile(
          onPageSelected: onPageSelected,
          title: "Món Ăn",
          svgSrc: "assets/icon/food.svg",
          onTap: () => onPageSelected(const SizedBox())),
      DrawerListTile(
          title: "Hồ sơ",
          svgSrc: "assets/icon/user.svg",
          onTap: () => onPageSelected(const ProfileScreen())),
      DrawerListTile(
          title: "Cài Đặt",
          svgSrc: "assets/icon/setting.svg",
          onTap: () => onPageSelected(const DashboardScreen())),
      DrawerListTile(
          title: 'Đăng Xuất',
          svgSrc: 'assets/icon/logout.svg',
          onTap: () => onPageSelected(const DashboardScreen()))
    ]));
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {super.key,
      required this.title,
      required this.svgSrc,
      required this.onTap});

  final String title, svgSrc;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(svgSrc,
            colorFilter:
                const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
            height: 16),
        title: Text(title));
  }
}

class DrawerExpansionTile extends StatelessWidget {
  const DrawerExpansionTile(
      {super.key,
      required this.title,
      required this.svgSrc,
      required this.onTap,
      required this.onPageSelected});

  final String title, svgSrc;
  final void Function()? onTap;
  final Function(Widget) onPageSelected;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: SvgPicture.asset(svgSrc,
            colorFilter:
                const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
            height: 16),
        title: Text(title),
        children: [
          ListTile(
              onTap: () =>
                  onPageSelected(const ListFoodIsShow(isShowFood: true)),
              horizontalTitleGap: 0.0,
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Đang hiển thị',
                      style: context.textStyleSmall!
                          .copyWith(color: Colors.white70)))),
          ListTile(
              onTap: () {
                onPageSelected(const ListFoodDontShow());
              },
              horizontalTitleGap: 0.0,
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Đang ẩn',
                      style: context.textStyleSmall!
                          .copyWith(color: Colors.white70))))
        ]);
  }
}
