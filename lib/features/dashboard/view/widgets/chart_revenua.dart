import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin/features/dashboard/cubit/data_chart_yesterday.dart';

class ChartRevenue extends StatefulWidget {
  const ChartRevenue({super.key});

  @override
  State<ChartRevenue> createState() => _ChartRevenueState();
}

class _ChartRevenueState extends State<ChartRevenue> {
  var defaultSpot1 = [
    const FlSpot(1, 0.1),
    const FlSpot(2, 1),
    const FlSpot(3, 0.2),
    const FlSpot(4, 0.3),
    const FlSpot(5, 0.2),
    const FlSpot(6, 0.4)
  ];

  var defaultSpot2 = [
    const FlSpot(1, 0.1),
    const FlSpot(2, 1),
    const FlSpot(3, 0.2),
    const FlSpot(4, 0.3),
    const FlSpot(5, 0.2),
    const FlSpot(6, 0.4)
  ];
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var dataCurent = context.watch<DataChartRevenueCubit>().state;
      var dataYesterday = context.watch<DataChartYesterdayCubit>().state;
      logger.d(dataCurent);
      logger.d(dataYesterday);
      return LineChart(dataChart(dataCurent, dataYesterday),
          duration: const Duration(milliseconds: 150));
    });
  }

  LineChartData dataChart(List<FlSpot> listData1, List<FlSpot> listData2) =>
      LineChartData(
          lineTouchData: lineTouchData,
          gridData: gridData,
          titlesData: titlesData,
          borderData: borderData,
          lineBarsData: lineBarsData(listData1, listData2));

  LineTouchData get lineTouchData => LineTouchData(
      // enabled: false,
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) =>
              touchedSpots.map((LineBarSpot touchedSpot) {
                final textStyle = TextStyle(
                    color: touchedSpot.bar.gradient?.colors.first ??
                        touchedSpot.bar.color ??
                        Colors.blueGrey,
                    fontWeight: FontWeight.bold);
                return LineTooltipItem(
                    Ultils.currencyFormat(touchedSpot.y * 1000000), textStyle);
              }).toList(),
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8)));

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: bottomTitles),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: leftTitles()));

  List<LineChartBarData> lineBarsData(
          List<FlSpot> listData1, List<FlSpot> listData2) =>
      [lineChartBarData1(listData1), lineChartBarData2(listData2)];

  SideTitles leftTitles() => const SideTitles(
        // showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => const SideTitles(
        showTitles: false,
        reservedSize: 32,
        interval: 1,
        // getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: const Border(
          // bottom: BorderSide(color: Colors.red, width: 4),
          // left: const BorderSide(color: Colors.transparent),
          // right: const BorderSide(color: Colors.transparent),
          // top: const BorderSide(color: Colors.transparent),
          ));

  LineChartBarData lineChartBarData1(List<FlSpot> listData) {
    return LineChartBarData(
        isCurved: true,
        color: context.colorScheme.secondary,
        barWidth: 5,
        isStrokeCapRound: true,
        curveSmoothness: 0.4,
        dotData: const FlDotData(show: false),
        // belowBarData: BarAreaData(
        //   show: true,
        //   // gradient: LinearGradient(
        //   //     begin: Alignment.topCenter,
        //   //     // end: const Alignment(0.8, 1),
        //   //     colors: <Color>[
        //   //       context.colorScheme.secondary.withOpacity(0.05),
        //   //       context.colorScheme.secondary.withOpacity(0.1),
        //   //       context.colorScheme.secondary.withOpacity(0.2)
        //   //     ],
        //   //     tileMode: TileMode.mirror)
        // ),
        spots: listData.isEmpty ? defaultSpot1 : listData);
  }

  LineChartBarData lineChartBarData2(List<FlSpot> listData) {
    return LineChartBarData(
        isCurved: true,
        color: context.colorScheme.primary.withOpacity(0.3),
        barWidth: 5,
        isStrokeCapRound: true,
        curveSmoothness: 0.4,
        dotData: const FlDotData(show: false),
        // belowBarData: BarAreaData(
        //     show: true,
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         // end: const Alignment(0.8, 1),
        //         colors: <Color>[
        //           context.colorScheme.primary.withOpacity(0.05),
        //           context.colorScheme.primary.withOpacity(0.1),
        //           context.colorScheme.primary.withOpacity(0.2)
        //         ],
        //         tileMode: TileMode.mirror)),
        spots: listData.isEmpty ? defaultSpot2 : listData);
  }
}
