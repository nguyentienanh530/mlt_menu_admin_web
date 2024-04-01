// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_bloc_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GenericBlocState<T> {
  List<T>? get datas => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenericBlocStateCopyWith<T, GenericBlocState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericBlocStateCopyWith<T, $Res> {
  factory $GenericBlocStateCopyWith(
          GenericBlocState<T> value, $Res Function(GenericBlocState<T>) then) =
      _$GenericBlocStateCopyWithImpl<T, $Res, GenericBlocState<T>>;
  @useResult
  $Res call({List<T>? datas, T? data, String? error, Status status});
}

/// @nodoc
class _$GenericBlocStateCopyWithImpl<T, $Res, $Val extends GenericBlocState<T>>
    implements $GenericBlocStateCopyWith<T, $Res> {
  _$GenericBlocStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datas = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      datas: freezed == datas
          ? _value.datas
          : datas // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenericBlocStateImplCopyWith<T, $Res>
    implements $GenericBlocStateCopyWith<T, $Res> {
  factory _$$GenericBlocStateImplCopyWith(_$GenericBlocStateImpl<T> value,
          $Res Function(_$GenericBlocStateImpl<T>) then) =
      __$$GenericBlocStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T>? datas, T? data, String? error, Status status});
}

/// @nodoc
class __$$GenericBlocStateImplCopyWithImpl<T, $Res>
    extends _$GenericBlocStateCopyWithImpl<T, $Res, _$GenericBlocStateImpl<T>>
    implements _$$GenericBlocStateImplCopyWith<T, $Res> {
  __$$GenericBlocStateImplCopyWithImpl(_$GenericBlocStateImpl<T> _value,
      $Res Function(_$GenericBlocStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datas = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? status = null,
  }) {
    return _then(_$GenericBlocStateImpl<T>(
      datas: freezed == datas
          ? _value._datas
          : datas // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ));
  }
}

/// @nodoc

class _$GenericBlocStateImpl<T> implements _GenericBlocState<T> {
  _$GenericBlocStateImpl(
      {final List<T>? datas,
      this.data,
      this.error,
      this.status = Status.loading})
      : _datas = datas;

  final List<T>? _datas;
  @override
  List<T>? get datas {
    final value = _datas;
    if (value == null) return null;
    if (_datas is EqualUnmodifiableListView) return _datas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final T? data;
  @override
  final String? error;
  @override
  @JsonKey()
  final Status status;

  @override
  String toString() {
    return 'GenericBlocState<$T>(datas: $datas, data: $data, error: $error, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericBlocStateImpl<T> &&
            const DeepCollectionEquality().equals(other._datas, _datas) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_datas),
      const DeepCollectionEquality().hash(data),
      error,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericBlocStateImplCopyWith<T, _$GenericBlocStateImpl<T>> get copyWith =>
      __$$GenericBlocStateImplCopyWithImpl<T, _$GenericBlocStateImpl<T>>(
          this, _$identity);
}

abstract class _GenericBlocState<T> implements GenericBlocState<T> {
  factory _GenericBlocState(
      {final List<T>? datas,
      final T? data,
      final String? error,
      final Status status}) = _$GenericBlocStateImpl<T>;

  @override
  List<T>? get datas;
  @override
  T? get data;
  @override
  String? get error;
  @override
  Status get status;
  @override
  @JsonKey(ignore: true)
  _$$GenericBlocStateImplCopyWith<T, _$GenericBlocStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
