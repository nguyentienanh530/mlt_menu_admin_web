import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/features/banner/view/screen/banner_screen.dart';
import 'package:mlt_menu_admin/features/food/view/widgets/list_food_dont_show.dart';
import 'package:mlt_menu_admin/features/food/view/widgets/list_food_is_show.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_current_screen.dart';
import 'package:mlt_menu_admin/features/table/view/screen/table_screen.dart';
import '../config/config.dart';
import '../features/home/view/screen/home_screen.dart';
import '../features/order/view/screen/order_history_screen.dart';
import '../features/table/view/screen/create_or_update_table.dart';
import 'package:mlt_menu_admin/features/category/view/screen/categories_screen.dart';
import 'package:mlt_menu_admin/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:mlt_menu_admin/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_history_detail_on_day_screen.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_on_table.dart';
import 'package:mlt_menu_admin/features/print/data/model/print_model.dart';
import 'package:mlt_menu_admin/features/print/view/screen/create_or_update_print.dart';
import 'package:mlt_menu_admin/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin/features/order/view/screen/add_food_to_order_screen.dart';
import 'package:mlt_menu_admin/features/food/view/screen/food_detail_screen.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_detail_screen.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_history_detail_screen.dart';
import 'package:mlt_menu_admin/features/order/view/screen/order_screen.dart';
import 'package:mlt_menu_admin/features/user/view/screen/change_password.dart';
import 'package:mlt_menu_admin/features/user/view/screen/profile_screen.dart';
import 'package:mlt_menu_admin/features/user/view/screen/update_user.dart';
import 'package:mlt_menu_admin/features/register/view/screen/signup_screen.dart';
import 'package:mlt_menu_admin/features/food/view/screen/create_or_update_food_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/food/data/model/food_model.dart';
import '../features/login/view/screen/login_screen.dart';
import '../core/utils/utils.dart';
import '../features/print/view/screen/print_screen.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn =
        context.watch<AuthBloc>().state.status == AuthStatus.authenticated;
    // var isLoggedIn = context.select<AuthBloc, bool>(
    //     (authBloc) => authBloc.state.status == AuthStatus.authenticated);
    var router = GoRouter(
        initialLocation: RouteName.home,
        redirect: (context, state) {
          final bool isPublicRoute =
              RouteName.publicRoutes.contains(state.fullPath);
          print('Login: $isLoggedIn');

          if (isLoggedIn && isPublicRoute) {
            return RouteName.home;
          }

          if (!isLoggedIn && !isPublicRoute) {
            return RouteName.login;
          }

          return null;
        },
        routes: [
          GoRoute(
              path: RouteName.home,
              builder: (context, state) =>
                  HomeScreen(child: DashboardScreen())),
          GoRoute(
              path: RouteName.createTable,
              builder: (context, state) {
                final arg =
                    GoRouterState.of(context).extra as Map<String, dynamic>;
                final mode = arg['mode'] as Mode;
                final table = arg['table'] ?? TableModel();
                return CreateOrUpdateTable(mode: mode, tableModel: table);
              }),
          GoRoute(
              path: RouteName.login,
              builder: (context, state) => const LoginScreen()),

          GoRoute(
              path: RouteName.register,
              builder: (context, state) => const SignUpScreen()),
          GoRoute(
              path: RouteName.addFood,
              builder: (context, state) => const AddFoodToOrderScreen()),
          GoRoute(
              path: RouteName.changePassword,
              builder: (context, state) => ChangePassword()),
          GoRoute(
              path: RouteName.printSeting,
              builder: (context, state) => const PrintScreen()),

          GoRoute(
              path: RouteName.foodDetail,
              builder: (context, state) {
                final Food foodModel = GoRouterState.of(context).extra as Food;
                return FoodDetailScreen(food: foodModel);
              }),
          GoRoute(
              path: RouteName.order,
              builder: (context, state) => const OrderScreen()),
          GoRoute(
              path: RouteName.orderOnTable,
              builder: (context, state) {
                final table = GoRouterState.of(context).extra as TableModel;
                return OrderOnTable(tableModel: table);
              }),
          GoRoute(
              path: RouteName.orderDetail,
              builder: (context, state) {
                final Orders orders = GoRouterState.of(context).extra as Orders;
                return OrderDetailScreen(orders: orders);
              }),
          GoRoute(
              path: RouteName.orderHistoryDetailOnDayScreen,
              name: RouteName.orderHistoryDetailOnDayScreen,
              builder: (context, state) {
                final List<Orders> orders =
                    GoRouterState.of(context).extra as List<Orders>;
                return OrderHistoryDetailOnDayScreen(orders: orders);
              }),
          GoRoute(
              path: RouteName.orderHistoryDetail,
              builder: (context, state) {
                final orders = GoRouterState.of(context).extra as Orders;
                return OrderHistoryDetailScreen(orders: orders);
              }),
          GoRoute(
              path: RouteName.createOrUpdateFood,
              builder: (context, state) {
                final data =
                    GoRouterState.of(context).extra as Map<String, dynamic>;
                final food = data['food'] as Food;
                final mode = data['mode'] as Mode;
                return CreateOrUpdateFoodScreen(food: food, mode: mode);
              }),
          GoRoute(
              path: RouteName.createOrUpdatePrint,
              builder: (context, state) {
                final data =
                    GoRouterState.of(context).extra as Map<String, dynamic>;
                final print = data['print'] as PrintModel;
                final mode = data['mode'] as Mode;
                return CreateOrUpdatePrint(printModel: print, mode: mode);
              }),
          GoRoute(
              path: RouteName.updateUser,
              builder: (context, state) {
                final UserModel user =
                    GoRouterState.of(context).extra as UserModel;
                return UpdateUser(user: user);
              }),

          ////////////////////////
          ////////////////////////
          ////////////////////////
          ////////////////////////
          ////////////////////////
          ////////////////////////
          ////////////////////////
          ShellRoute(
              builder:
                  (BuildContext context, GoRouterState state, Widget child) {
                return HomeScreen(child: child);
              },
              routes: [
                GoRoute(
                    path: RouteName.dashboard,
                    builder: (context, state) => DashboardScreen()),
                GoRoute(
                    name: RouteName.listFood,
                    path: '${RouteName.listFood}/:show',
                    builder: (context, state) {
                      var data = '';
                      data = state.pathParameters['show'] ?? 'show';
                      return data == 'show'
                          ? const ListFoodIsShow(isShowFood: true)
                          : const ListFoodDontShow();
                    }),
                GoRoute(
                    path: RouteName.currentOrder,
                    builder: (context, state) => const CurrentOrder()),
                GoRoute(
                    path: RouteName.historyOrder,
                    builder: (context, state) => const OrderHistoryScreen()),
                GoRoute(
                    path: RouteName.profile,
                    builder: (context, state) => const ProfileScreen()),
                GoRoute(
                    path: RouteName.categoriesScreen,
                    builder: (context, state) => const CategoriesScreen()),
                GoRoute(
                    path: RouteName.table,
                    builder: (context, state) => const TableScreen()),
                GoRoute(
                    path: RouteName.banner,
                    builder: (context, state) => const BannerScreen()),
              ])
          //////////////////////
          ////////////////////////
          ///////////////////////////
          ///////////////////////////////////////////////////////////////////////////
        ]);
    return MaterialApp.router(
        title: 'Minh Long Menu',
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        // routerDelegate: router.routerDelegate,
        // routeInformationParser: router.routeInformationParser,
        // routeInformationProvider: router.routeInformationProvider,
        routerConfig: router);
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
