import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'table_model.freezed.dart';
part 'table_model.g.dart';

@freezed
class TableModel with _$TableModel {
  factory TableModel(
      {@Default('') String? id,
      @Default('') String name,
      @Default(0) int seats,
      @Default(false) bool isUse}) = _TableModel;

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);
}
