import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataChartRevenueCubit extends Cubit<List<FlSpot>> {
  DataChartRevenueCubit() : super(<FlSpot>[]);
  onDataChartRevenueChanged(List<FlSpot> newDataChartRevenue) =>
      emit(newDataChartRevenue);
}
