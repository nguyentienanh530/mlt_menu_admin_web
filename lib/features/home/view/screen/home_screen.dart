import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/widget/common_side_menu.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin/common/widget/responsive.dart';
import 'package:mlt_menu_admin/config/router.dart';
import 'package:mlt_menu_admin/features/auth/bloc/auth_bloc.dart';
import 'package:mlt_menu_admin/features/category/view/screen/categories_screen.dart';
import 'package:mlt_menu_admin/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:mlt_menu_admin/features/food/view/widgets/list_food_dont_show.dart';
import 'package:mlt_menu_admin/features/food/view/widgets/list_food_is_show.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_current_screen.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_history_screen.dart';
import 'package:mlt_menu_admin/features/table/view/screen/table_screen.dart';
import 'package:mlt_menu_admin/features/user/bloc/user_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/features/user/view/screen/profile_screen.dart';
import 'package:user_repository/user_repository.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/print_data_source/print_data_source.dart';
import '../../../user/data/model/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(), child: HomeView(child: child));
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.child});
  final Widget child;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController controller = PageController();
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // _updateToken();
    // sideMenuController.addListener((index) {
    //   controller.jumpToPage(index);
    // });

    sideMenuController.addListener(
      (index) {
        print(index);
      },
    );
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
    if (!mounted) return;
    UserRepository(firebaseFirestore: FirebaseFirestore.instance)
        .updateAdminToken(userID: _getUserID(), token: token ?? '');
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  // _handelUpdate(String userID, String token) {
  //   context.read<UserBloc>().add(UpdateToken(userID: userID, token: token));
  // }

  final lstPage = [
    DashboardScreen(),
    const ListFoodIsShow(isShowFood: true),
    const ListFoodDontShow(),
    const CurrentOrder(),
    const OrderHistoryScreen(),
    const TableScreen(),
    const CategoriesScreen(),
    const ProfileScreen()
  ];

  // int _calculateSelectedIndex(BuildContext context) {
  //   final GoRouter route = GoRouter.of(context);
  //   final String location =
  //       route.routerDelegate.currentConfiguration.last.toString();
  //   print(location);
  //   if (location == RouteName.dashboard) {
  //     return 0;
  //   } else if (location == RouteName.profile) {
  //     return 1;
  //   }
  //   return 0;
  // }

  void onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteName.dashboard);
        break;

      case 1:
        context.go(RouteName.profile);
        break;

      default:
        return context.go(RouteName.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserBloc>().state;

    return BlocConsumer<UserBloc, GenericBlocState<UserModel>>(
        builder: (context, state) {
      switch (userState.status) {
        case Status.loading:
          return const LoadingScreen();
        case Status.empty:
          return const EmptyScreen();
        case Status.failure:
          return ErrorScreen(errorMsg: userState.error ?? '');
        case Status.success:
          if (userState.data?.role == 'admin') {
            // _updateToken();
            return Scaffold(
                key: _key,
                drawer: CommonSideMenu(
                    controller: sideMenuController, globalKey: _key),
                appBar: AppBar(
                    backgroundColor:
                        context.colorScheme.primary.withOpacity(0.1),
                    centerTitle: true,
                    title: Text(userState.data?.name ?? '',
                        style: context.titleStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    automaticallyImplyLeading:
                        Responsive.isDesktop(context) ? false : true),
                body: Responsive(
                    mobile: _buildMobileWidget(),
                    tablet: _buildMobileWidget(),
                    desktop: _buildWebWidget()));
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
    }, listener: (context, state) {
      // if (state.status == Status.success) {
      //   context.go(RouteName.dashboard);
      // }
    });
  }

  Widget _buildMobileWidget() {
    return SizedBox(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (Responsive.isDesktop(context))
        Expanded(
            child: CommonSideMenu(
                controller: sideMenuController, globalKey: _key)),
      Expanded(
          flex: 5,
          child:
              Padding(padding: const EdgeInsets.all(16), child: widget.child))
    ]));
  }

  Widget _buildWebWidget() {
    return SizedBox(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (Responsive.isDesktop(context))
        Expanded(
            child: CommonSideMenu(
                controller: sideMenuController, globalKey: _key)),
      Expanded(
          flex: 5,
          child:
              Padding(padding: const EdgeInsets.all(16.0), child: widget.child))
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
                padding: const EdgeInsets.only(left: 16), child: Text(title))));
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
