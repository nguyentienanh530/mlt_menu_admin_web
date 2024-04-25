import 'package:mlt_menu_admin/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin/features/dashboard/cubit/total_price_yesterday_cubit.dart';
import 'package:mlt_menu_admin/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/data_chart_yesterday.dart';
import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => OrderBloc()),
      BlocProvider(create: (context) => TableBloc()),
      BlocProvider(create: (context) => DailyRevenueCubit()),
      BlocProvider(create: (context) => TotalPriceYesterday()),
      BlocProvider(create: (context) => DataChartRevenueCubit()),
      BlocProvider(create: (context) => DataChartYesterdayCubit())
    ], child: const SafeArea(child: DashboardView()));
  }
}
