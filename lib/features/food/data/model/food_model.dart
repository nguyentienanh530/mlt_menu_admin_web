// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_model.freezed.dart';
part 'food_model.g.dart';

// DateTime _sendAtFromJson(Timestamp timestamp) =>
//     DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

// Timestamp _sendAtFromJson(Timestamp timestamp) => timestamp;

@freezed
class Food with _$Food {
  factory Food(
      {@Default('') String id,
      @Default('') String image,
      @Default(false) bool isDiscount,
      @Default(false) bool isShowFood,
      @Default('') String description,
      @Default('') String categoryID,
      @Default(0) int discount,
      @Default(0) num price,
      @Default('') String name,
      @Default(0) int count,
      @Default(<dynamic>[]) List photoGallery,
      String? createAt}) = _Food;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}

// Phần extension này cần được thêm vào để hỗ trợ serialize/deserialize
// extension ReferenceSerializer on Reference {
//   static Reference fromJson(String id) => Reference();
//   static String toJson(Reference reference) => reference.toJson();
// }

// @JsonSerializable()
// class Reference {
//   final String id;

//   Reference({required this.id});

//   factory Reference.fromId(String id) => Reference(id: id);

//   String getId() => id;

//   Map<String, dynamic> toJson() => {'id': id};
// }
