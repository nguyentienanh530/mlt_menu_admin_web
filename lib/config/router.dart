import 'package:mlt_menu_admin_web/features/category/data/model/category_model.dart';
import 'package:mlt_menu_admin_web/features/category/view/screen/categories_screen.dart';
import 'package:mlt_menu_admin_web/features/category/view/screen/create_or_update_category.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_on_table.dart';
import 'package:mlt_menu_admin_web/features/print/data/model/print_model.dart';
import 'package:mlt_menu_admin_web/features/print/view/screen/create_or_update_print.dart';
import 'package:mlt_menu_admin_web/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/add_food_to_order_screen.dart';
import 'package:mlt_menu_admin_web/features/food/view/screen/food_detail_screen.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_detail_screen.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_history_detail_screen.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_screen.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/change_password.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/update_user.dart';
import 'package:mlt_menu_admin_web/features/food/view/screen/food_screen.dart';
import 'package:mlt_menu_admin_web/features/register/view/screen/signup_screen.dart';
import 'package:mlt_menu_admin_web/features/table/view/screen/create_or_update_table.dart';
import 'package:mlt_menu_admin_web/features/food/view/screen/create_or_update_food_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/food/data/model/food_model.dart';
import '../features/home/view/screen/home_screen.dart';
import '../features/login/view/screen/login_screen.dart';
import '../core/utils/utils.dart';
import '../features/print/view/screen/print_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String searchFood = '/searchFood';
  static const String foodDetail = '/foodDetail';
  static const String order = '/order';
  static const String orderDetail = '/orderDetail';
  static const String addFood = '/addFood';
  static const String orderHistoryDetail = '/orderHistoryDetail';
  static const String createTable = '/createTable';
  static const String updateUser = '/updateUser';
  static const String changePassword = '/changePassword';
  static const String printSeting = '/printSeting';
  static const String createOrUpdateFood = '/createOrUpdateFood';
  static const String orderOnTable = '/orderOnTable';
  static const String createOrUpdatePrint = '/createOrUpdatePrint';
  static const String categoriesScreen = '/categoriesScreen';
  static const String createOrUpdateCategory = '/createOrUpdateCategory';

  static const publicRoutes = [login, register];
}

final router = GoRouter(
    redirect: (context, state) {
      if (RouteName.publicRoutes.contains(state.fullPath)) {
        return null;
      }
      if (context.read<AuthBloc>().state.status == AuthStatus.authenticated) {
        return null;
      }
      return RouteName.login;
    },
    routes: [
      GoRoute(
          path: RouteName.home,
          builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: RouteName.createTable,
          builder: (context, state) {
            final arg = GoRouterState.of(context).extra as Map<String, dynamic>;
            final mode = arg['mode'] as Mode;
            final table = arg['table'] ?? TableModel();
            return CreateTable(mode: mode, tableModel: table);
          }),
      GoRoute(
          path: RouteName.login,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: RouteName.register,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(
          path: RouteName.searchFood,
          builder: (context, state) => const FoodScreen()),
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
          path: RouteName.categoriesScreen,
          builder: (context, state) => const CategoriesScreen()),
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
            final UserModel user = GoRouterState.of(context).extra as UserModel;
            return UpdateUser(user: user);
          }),
      GoRoute(
          path: RouteName.createOrUpdateCategory,
          builder: (context, state) {
            final data =
                GoRouterState.of(context).extra as Map<String, dynamic>;
            final categoryModel = data['categoryModel'] as CategoryModel;
            final mode = data['mode'] as Mode;
            return CreateOrUpdateCategory(
                categoryModel: categoryModel, mode: mode);
          }),
    ]);
