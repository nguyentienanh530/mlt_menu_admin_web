import 'package:mlt_menu_admin_web/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:mlt_menu_admin_web/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => OrderBloc()),
      BlocProvider(create: (context) => TableBloc()),
      BlocProvider(create: (context) => DailyRevenueCubit()),
      BlocProvider(create: (context) => DataChartRevenueCubit())
    ], child: const Scaffold(body: DashboardView()));
  }
}
