import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataChartYesterdayCubit extends Cubit<List<FlSpot>> {
  DataChartYesterdayCubit() : super(<FlSpot>[]);
  onDataChartYesterdayChanged(List<FlSpot> newDataChartRevenue) =>
      emit(newDataChartRevenue);
}
