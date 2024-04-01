import 'package:flutter_bloc/flutter_bloc.dart';

class DailyRevenueCubit extends Cubit<double> {
  DailyRevenueCubit() : super(0.0);
  onDailyRevenueChanged(double newDailyRevenue) => emit(newDailyRevenue);
}
