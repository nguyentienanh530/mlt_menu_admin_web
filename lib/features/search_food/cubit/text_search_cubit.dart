import 'package:flutter_bloc/flutter_bloc.dart';

class TextSearchCubit extends Cubit<String> {
  TextSearchCubit() : super('');
  void textChanged(String text) => emit(text);
  void clear() => emit('');
}
