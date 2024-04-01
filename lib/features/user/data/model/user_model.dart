import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel(
      {@Default('') String? id,
      @Default('') String name,
      @Default('') String email,
      @Default('') String image,
      @Default('') String phoneNumber,
      @Default('') String role,
      @Default('') String createAt}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
