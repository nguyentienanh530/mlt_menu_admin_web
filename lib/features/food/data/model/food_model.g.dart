// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodImpl _$$FoodImplFromJson(Map<String, dynamic> json) => _$FoodImpl(
      id: json['id'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isDiscount: json['isDiscount'] as bool? ?? false,
      isShowFood: json['isShowFood'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      categoryID: json['categoryID'] as String? ?? '',
      discount: json['discount'] as int? ?? 0,
      price: json['price'] as num? ?? 0,
      name: json['name'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      photoGallery: json['photoGallery'] as List<dynamic>? ?? const <dynamic>[],
      createAt: json['createAt'] as String?,
    );

Map<String, dynamic> _$$FoodImplToJson(_$FoodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'isDiscount': instance.isDiscount,
      'isShowFood': instance.isShowFood,
      'description': instance.description,
      'categoryID': instance.categoryID,
      'discount': instance.discount,
      'price': instance.price,
      'name': instance.name,
      'count': instance.count,
      'photoGallery': instance.photoGallery,
      'createAt': instance.createAt,
    };
