import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/common/widget/error_widget.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/total_price_yesterday_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/view/widgets/best_seller_view.dart';
import 'package:mlt_menu_admin_web/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_admin_web/features/food/data/model/food_model.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/features/order/data/model/order_model.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/common/widget/loading_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../common/widget/empty_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../cubit/data_chart_yesterday.dart';
import '../widgets/chart_revenua.dart';
import '../widgets/item_child_of_order_info.dart';
import '../widgets/item_table.dart';
part '../components/_mobile_page.dart';
part '../components/_web_page.dart';
part '../components/_performance.dart';
part '../components/_daily_revenue.dart';
part '../components/_order_on_day.dart';
part '../components/_list_table.dart';
part '../components/_left_info.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (!mounted) return;
    context.read<OrderBloc>().add(NewOrdersFecthed());
    context.read<TableBloc>().add(TablesOnStreamFetched());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          getData();
        },
        child: SingleChildScrollView(
            primary: true,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Responsive(mobile: mobile, tablet: mobile, desktop: web)));
  }

  Widget _buildItem(
      {required String svg, required String title, required String value}) {
    return Expanded(
        child: Card(
            elevation: 10,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(svg,
                                    colorFilter: ColorFilter.mode(
                                        context.colorScheme.secondary,
                                        BlendMode.srcIn)),
                                const SizedBox(height: 8),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(title,
                                        style: context.textStyleSmall!.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5))))
                              ])),
                      Expanded(
                          child: Center(
                              child: Text(value,
                                  style: context.titleStyleMedium!
                                      .copyWith(fontWeight: FontWeight.bold))))
                    ]))));
  }

  Widget _buildTitle({required String title}) {
    return Text(title,
        style: context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildLoadingItem() => const Expanded(child: LoadingScreen());

  Widget _buildNewOrder() {
    var newOrder = context.watch<OrderBloc>().state;
    return switch (newOrder.status) {
      Status.loading => _buildLoadingItem(),
      Status.empty => _buildItem(
          svg: 'assets/icon/cart.svg', title: 'Đơn hàng mới', value: '0'),
      Status.failure =>
        Text(newOrder.error ?? '', style: context.textStyleSmall),
      Status.success => _buildItem(
          svg: 'assets/icon/cart.svg',
          title: 'Đơn hàng mới',
          value: newOrder.datas!.length.toString())
    };
  }

  Widget buildInfo(BuildContext context, int tableIsUseNumber) {
    return SizedBox(
        height: Responsive.isMobile(context)
            ? context.sizeDevice.height * 0.1
            : context.sizeDevice.height * 0.15,
        child: Column(children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                _buildNewOrder(),
                SizedBox(width: defaultPadding / 2),
                orderOnDay,
                SizedBox(width: defaultPadding / 2),
                _buildItem(
                    svg: 'assets/icon/dinner_table.svg',
                    title: 'Bàn sử dụng',
                    value: tableIsUseNumber.toString())
              ]))
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
