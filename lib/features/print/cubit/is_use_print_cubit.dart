import 'package:flutter_bloc/flutter_bloc.dart';

class IsUsePrintCubit extends Cubit<bool> {
  IsUsePrintCubit() : super(false);
  onUsePrintChanged(bool isUse) => emit(isUse);
}
