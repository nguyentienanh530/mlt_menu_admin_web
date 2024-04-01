// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodDtoImpl _$$FoodDtoImplFromJson(Map<String, dynamic> json) =>
    _$FoodDtoImpl(
      foodID: json['foodID'] as String? ?? '',
      foodName: json['foodName'] as String? ?? '',
      foodImage: json['foodImage'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      isDiscount: json['isDiscount'] as bool? ?? false,
      discount: json['discount'] as num? ?? 0,
      foodPrice: json['foodPrice'] as num? ?? 0,
      note: json['note'] as String? ?? '',
      totalPrice: json['totalPrice'] as num? ?? 0,
    );

Map<String, dynamic> _$$FoodDtoImplToJson(_$FoodDtoImpl instance) =>
    <String, dynamic>{
      'foodID': instance.foodID,
      'foodName': instance.foodName,
      'foodImage': instance.foodImage,
      'quantity': instance.quantity,
      'isDiscount': instance.isDiscount,
      'discount': instance.discount,
      'foodPrice': instance.foodPrice,
      'note': instance.note,
      'totalPrice': instance.totalPrice,
    };
