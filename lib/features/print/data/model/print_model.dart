import 'package:freezed_annotation/freezed_annotation.dart';
part 'print_model.freezed.dart';
part 'print_model.g.dart';

@freezed
class PrintModel with _$PrintModel {
  factory PrintModel(
      {@Default('') String id,
      @Default('') String name,
      @Default('') String ip,
      @Default('') String port}) = _PrintModel;

  factory PrintModel.fromJson(Map<String, dynamic> json) =>
      _$PrintModelFromJson(json);
}
