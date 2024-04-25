import 'dart:async';
import 'package:mlt_menu_admin/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/features/food/data/provider/remote/food_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import '../data/model/food_model.dart';
part 'food_event.dart';

typedef Emit = Emitter<GenericBlocState<Food>>;

class FoodBloc extends Bloc<FoodEvent, GenericBlocState<Food>>
    with BlocHelper<Food> {
  FoodBloc() : super(GenericBlocState.loading()) {
    on<FoodsFetched>(_fetchFoods);
    on<FoodsPopulerFetched>(_fetchFoodsPopuler);
    on<FoodCreated>(_createFood);
    on<ResetData>(_resetData);
    on<DeleteFood>(_deleteFood);
    on<FoodUpdated>(_updateFood);
    on<GetFoodByID>(_getFoodByID);
  }
  final _foodRepository = FoodRepo(
      foodRepository:
          FoodRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _fetchFoods(FoodsFetched event, Emit emit) async {
    await getItems(
        _foodRepository.getFoods(isShowFood: event.isShowFood), emit);
  }

  FutureOr<void> _createFood(FoodCreated event, Emit emit) async {
    await createItem(_foodRepository.createFood(food: event.food), emit);
  }

  FutureOr<void> _resetData(ResetData event, Emit emit) {
    // emit(const FoodState());
  }

  FutureOr<void> _deleteFood(DeleteFood event, Emit emit) async {
    await deleteItem(_foodRepository.deleteFood(foodID: event.foodID), emit);
  }

  FutureOr<void> _updateFood(FoodUpdated event, Emit emit) async {
    await updateItem(_foodRepository.updateFood(food: event.food), emit);
  }

  FutureOr<void> _getFoodByID(GetFoodByID event, Emit emit) async {
    await getItem(_foodRepository.getFoodByID(foodID: event.foodID), emit);
  }

  FutureOr<void> _fetchFoodsPopuler(
      FoodsPopulerFetched event, Emit emit) async {
    await getItems(
        _foodRepository.getFoodsPopuler(isShowFood: event.isShowFood), emit);
  }
}
