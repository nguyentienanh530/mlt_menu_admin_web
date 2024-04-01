// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'print_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrintModel _$PrintModelFromJson(Map<String, dynamic> json) {
  return _PrintModel.fromJson(json);
}

/// @nodoc
mixin _$PrintModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrintModelCopyWith<PrintModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintModelCopyWith<$Res> {
  factory $PrintModelCopyWith(
          PrintModel value, $Res Function(PrintModel) then) =
      _$PrintModelCopyWithImpl<$Res, PrintModel>;
  @useResult
  $Res call({String id, String name, String ip, String port});
}

/// @nodoc
class _$PrintModelCopyWithImpl<$Res, $Val extends PrintModel>
    implements $PrintModelCopyWith<$Res> {
  _$PrintModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrintModelImplCopyWith<$Res>
    implements $PrintModelCopyWith<$Res> {
  factory _$$PrintModelImplCopyWith(
          _$PrintModelImpl value, $Res Function(_$PrintModelImpl) then) =
      __$$PrintModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String ip, String port});
}

/// @nodoc
class __$$PrintModelImplCopyWithImpl<$Res>
    extends _$PrintModelCopyWithImpl<$Res, _$PrintModelImpl>
    implements _$$PrintModelImplCopyWith<$Res> {
  __$$PrintModelImplCopyWithImpl(
      _$PrintModelImpl _value, $Res Function(_$PrintModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_$PrintModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrintModelImpl implements _PrintModel {
  _$PrintModelImpl(
      {this.id = '', this.name = '', this.ip = '', this.port = ''});

  factory _$PrintModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String ip;
  @override
  @JsonKey()
  final String port;

  @override
  String toString() {
    return 'PrintModel(id: $id, name: $name, ip: $ip, port: $port)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.port, port) || other.port == port));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, ip, port);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintModelImplCopyWith<_$PrintModelImpl> get copyWith =>
      __$$PrintModelImplCopyWithImpl<_$PrintModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintModelImplToJson(
      this,
    );
  }
}

abstract class _PrintModel implements PrintModel {
  factory _PrintModel(
      {final String id,
      final String name,
      final String ip,
      final String port}) = _$PrintModelImpl;

  factory _PrintModel.fromJson(Map<String, dynamic> json) =
      _$PrintModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ip;
  @override
  String get port;
  @override
  @JsonKey(ignore: true)
  _$$PrintModelImplCopyWith<_$PrintModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
