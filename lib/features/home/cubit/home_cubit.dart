import 'package:flutter_bloc/flutter_bloc.dart';

class IndexBottomBarCubit extends Cubit<int> {
  IndexBottomBarCubit() : super(0);
  void indexChanged(int index) => emit(index);
}
