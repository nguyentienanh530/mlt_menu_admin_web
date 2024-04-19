import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/error_screen.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin_web/config/router.dart';
import 'package:mlt_menu_admin_web/features/auth/bloc/auth_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/view/screen/categories_screen.dart';
import 'package:mlt_menu_admin_web/features/food/view/widgets/list_food_is_show.dart';
import 'package:mlt_menu_admin_web/features/home/cubit/home_cubit.dart';
import 'package:mlt_menu_admin_web/features/table/view/screen/table_screen.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/profile_screen.dart';
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
import '../../../order/view/screen/order_current_screen.dart';
import '../../../order/view/screen/order_history_screen.dart';
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
  final _key = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserBloc>().state;
    var currentPageState = context.watch<PageHomeCubit>().state;
    switch (userState.status) {
      case Status.loading:
        return const LoadingScreen();
      case Status.empty:
        return const EmptyScreen();
      case Status.failure:
        return ErrorScreen(errorMsg: userState.error ?? '');
      case Status.success:
        if (userState.data?.role == 'admin') {
          _updateToken();
          return Scaffold(
              key: _key,
              // appBar: _buildAppbar(),
              drawer: SideMenu(
                  scafoldKey: _key,
                  onPageSelected: (page) {
                    _key.currentState!.closeDrawer();
                    context.read<PageHomeCubit>().pageChanged(page);
                  }),
              body: SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (Responsive.isDesktop(context))
                      Expanded(
                          child: SideMenu(
                              scafoldKey: _key,
                              onPageSelected: (page) {
                                context.read<PageHomeCubit>().pageChanged(page);
                              })),
                    Expanded(
                        flex: 5,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              Expanded(flex: 5, child: currentPageState)
                            ])))
                  ])));
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
  final GlobalKey<ScaffoldState> scafoldKey;
  const SideMenu(
      {super.key, required this.onPageSelected, required this.scafoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      DrawerHeader(child: Image.asset("assets/image/logo.png")),
      DrawerListTile(
          title: "Dashboard",
          svgSrc: "assets/icon/home.svg",
          onTap: () {
            // context.pushReplacement(RouteName.dashboard);
            onPageSelected(const DashboardScreen());
          }),
      DrawerExpansionTile(
          title: "Món Ăn",
          title1: 'Đang hiển thị',
          title2: 'Đang ẩn',
          svgSrc: "assets/icon/food.svg",
          onTap1: () => onPageSelected(const ListFoodIsShow(isShowFood: true)),
          onTap2: () => onPageSelected(const ListFoodDontShow())),
      DrawerExpansionTile(
          title: "Đơn hàng",
          title1: 'Đơn hàng hiện tại',
          title2: 'Lịch sử đơn hàng',
          svgSrc: "assets/icon/ordered.svg",
          onTap1: () => onPageSelected(const CurrentOrder()),
          onTap2: () => onPageSelected(OrderHistoryScreen(
              onPressed: () => scafoldKey.currentState!.openDrawer()))),
      DrawerListTile(
          title: "Bàn ăn",
          svgSrc: "assets/icon/chair.svg",
          onTap: () {
            onPageSelected(const TableScreen());
          }),
      DrawerListTile(
          title: "Danh mục",
          svgSrc: "assets/icon/category.svg",
          onTap: () {
            onPageSelected(const CategoriesScreen());
          }),
      DrawerListTile(
          title: "Cài Đặt",
          svgSrc: "assets/icon/setting.svg",
          onTap: () {
            onPageSelected(const ProfileScreen());
          })
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //  hoverColor: ,
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          horizontalTitleGap: 0.0,
          leading: SvgPicture.asset(svgSrc,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 20),
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(title),
          )),
    );
  }
}

class DrawerExpansionTile extends StatelessWidget {
  const DrawerExpansionTile(
      {super.key,
      required this.title,
      required this.svgSrc,
      required this.onTap1,
      required this.onTap2,
      required this.title1,
      required this.title2});

  final String title, title1, title2, svgSrc;
  final void Function()? onTap1;
  final void Function()? onTap2;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
            leading: SvgPicture.asset(svgSrc,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 20),
            title: Text(title),
            children: [
              ListTile(
                  onTap: onTap1,
                  horizontalTitleGap: 0.0,
                  title: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(title1,
                          style: context.textStyleSmall!
                              .copyWith(color: Colors.white70)))),
              ListTile(
                  onTap: onTap2,
                  horizontalTitleGap: 0.0,
                  title: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(title2,
                          style: context.textStyleSmall!
                              .copyWith(color: Colors.white70))))
            ]));
  }
}
