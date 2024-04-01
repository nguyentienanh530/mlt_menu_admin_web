// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrintModelImpl _$$PrintModelImplFromJson(Map<String, dynamic> json) =>
    _$PrintModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ip: json['ip'] as String? ?? '',
      port: json['port'] as String? ?? '',
    );

Map<String, dynamic> _$$PrintModelImplToJson(_$PrintModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ip': instance.ip,
      'port': instance.port,
    };
