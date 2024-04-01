import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartRevenue extends StatefulWidget {
  const ChartRevenue({super.key});

  @override
  State<ChartRevenue> createState() => _ChartRevenueState();
}

class _ChartRevenueState extends State<ChartRevenue> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<DataChartRevenueCubit>().state;
    return Padding(
        padding:
            const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
        child: LineChart(dataChart(data),
            duration: const Duration(milliseconds: 250)));
  }

  LineChartData dataChart(List<FlSpot> listData) => LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData(listData));

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
                    Ultils.currencyFormat(touchedSpot.y), textStyle);
              }).toList(),
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8)));

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: bottomTitles),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: leftTitles()));

  List<LineChartBarData> lineBarsData(List<FlSpot> listData) =>
      [lineChartBarData(listData)];

  SideTitles leftTitles() => const SideTitles(
        // getTitlesWidget: leftTitleWidgets,
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

  LineChartBarData lineChartBarData(List<FlSpot> listData) {
    return LineChartBarData(
        isCurved: true,
        color: context.colorScheme.secondary,
        barWidth: 3,
        isStrokeCapRound: true,
        curveSmoothness: 0.4,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                // end: const Alignment(0.8, 1),
                colors: <Color>[
                  context.colorScheme.secondary.withOpacity(0.05),
                  context.colorScheme.secondary.withOpacity(0.1),
                  context.colorScheme.secondary.withOpacity(0.2)
                ],
                tileMode: TileMode.mirror)),
        spots: listData);
  }
}
