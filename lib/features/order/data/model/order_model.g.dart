// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrdersImpl _$$OrdersImplFromJson(Map<String, dynamic> json) => _$OrdersImpl(
      id: json['id'] as String?,
      status: json['status'] as String?,
      tableID: json['tableID'] as String?,
      tableName: json['tableName'] as String? ?? '',
      orderTime: json['orderTime'] as String?,
      payTime: json['payTime'] as String?,
      totalPrice: json['totalPrice'] as num?,
      foods: (json['foods'] as List<dynamic>?)
              ?.map((e) => FoodDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodDto>[],
    );

Map<String, dynamic> _$$OrdersImplToJson(_$OrdersImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'tableID': instance.tableID,
      'tableName': instance.tableName,
      'orderTime': instance.orderTime,
      'payTime': instance.payTime,
      'totalPrice': instance.totalPrice,
      'foods': foodDtoListToJson(instance.foods),
    };
