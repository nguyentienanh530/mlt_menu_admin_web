import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_dto.freezed.dart';
part 'food_dto.g.dart';

@freezed
class FoodDto with _$FoodDto {
  factory FoodDto(
      {@Default('') String foodID,
      @Default('') String foodName,
      @Default('') String foodImage,
      @Default(1) int quantity,
      @Default(false) bool isDiscount,
      @Default(0) num discount,
      @Default(0) num foodPrice,
      @Default('') String note,
      @Default(0) num totalPrice}) = _FoodDto;

  factory FoodDto.fromJson(Map<String, dynamic> json) =>
      _$FoodDtoFromJson(json);
}
