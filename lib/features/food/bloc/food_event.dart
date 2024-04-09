part of 'food_bloc.dart';

sealed class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

final class FoodsFetched extends FoodEvent {
  final bool isShowFood;

  const FoodsFetched({required this.isShowFood});
}

final class FoodsPopulerFetched extends FoodEvent {
  final bool isShowFood;

  const FoodsPopulerFetched({required this.isShowFood});
}

final class GetFoodByID extends FoodEvent {
  final String foodID;

  const GetFoodByID({required this.foodID});
}

final class ResetData extends FoodEvent {}

final class DeleteFood extends FoodEvent {
  final String foodID;

  const DeleteFood({required this.foodID});
}

final class FoodCreated extends FoodEvent {
  final Food food;

  const FoodCreated({required this.food});
}

final class FoodUpdated extends FoodEvent {
  final Food food;

  const FoodUpdated({required this.food});
}
