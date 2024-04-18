import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPriceYesterday extends Cubit<double> {
  TotalPriceYesterday() : super(0.0);
  onTotalPriceYesterdayChanged(double newtotalPriceYesterday) =>
      emit(newtotalPriceYesterday);
}
