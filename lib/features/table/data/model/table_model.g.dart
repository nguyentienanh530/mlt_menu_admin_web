// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableModelImpl _$$TableModelImplFromJson(Map<String, dynamic> json) =>
    _$TableModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      seats: json['seats'] as int? ?? 0,
      isUse: json['isUse'] as bool? ?? false,
    );

Map<String, dynamic> _$$TableModelImplToJson(_$TableModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'seats': instance.seats,
      'isUse': instance.isUse,
    };
