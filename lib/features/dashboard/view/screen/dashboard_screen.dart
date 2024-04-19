import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/core/utils/extensions.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/total_price_yesterday_cubit.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => TableBloc()),
          BlocProvider(create: (context) => DailyRevenueCubit()),
          BlocProvider(create: (context) => TotalPriceYesterday()),
          BlocProvider(create: (context) => DataChartRevenueCubit())
        ],
        child: CustomScrollView(slivers: [
          SliverAppBar(
              pinned: true,
              stretch: true,
              automaticallyImplyLeading:
                  Responsive.isDesktop(context) ? false : true,
              centerTitle: true,
              title: Text('Quản lý',
                  style: context.titleStyleMedium!
                      .copyWith(fontWeight: FontWeight.bold))),
          const SliverToBoxAdapter(child: DashboardView())
        ]));
  }

  // _buildAppbar(BuildContext context) => AppBar(
  //     title: Text('Quản lý', style: context.titleStyleMedium),
  //     centerTitle: true,
  //     leading: Responsive.isDesktop(context)
  //         ? const SizedBox()
  //         : IconButton(
  //             icon: const Icon(Icons.menu),
  //             onPressed: () => _key.currentState!.openDrawer()));
}
