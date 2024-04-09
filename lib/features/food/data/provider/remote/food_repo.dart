import 'package:mlt_menu_admin_web/common/firebase/firebase_result.dart';
import 'package:food_repository/food_repository.dart';
import '../../../../../common/firebase/firebase_base.dart';
import '../../model/food_model.dart';

class FoodRepo extends FirebaseBase<Food> {
  final FoodRepository _foodRepository;

  FoodRepo({required FoodRepository foodRepository})
      : _foodRepository = foodRepository;

  Future<FirebaseResult<List<Food>>> getFoods(
      {required bool isShowFood}) async {
    try {
      return await getItems(
          await _foodRepository.getFoods(isShowFood: isShowFood),
          Food.fromJson);
    } catch (e) {
      throw '$e';
    }
  }

  Future<FirebaseResult<List<Food>>> getFoodsPopuler(
      {required bool isShowFood}) async {
    try {
      return await getItems(
          await _foodRepository.getFoodsPopuler(isShowFood: isShowFood),
          Food.fromJson);
    } catch (e) {
      throw '$e';
    }
  }

  Future<FirebaseResult<Food>> getFoodByID({required String foodID}) async {
    return await getItem(await _foodRepository.getFoodByID(foodID: foodID),
        (json) => Food.fromJson(json));
  }

  Future<FirebaseResult<bool>> createFood({required Food food}) async {
    try {
      return await createItem(_foodRepository.createFood(food.toJson()));
    } catch (e) {
      throw '$e';
    }
  }

  Future<FirebaseResult<bool>> deleteFood({required String foodID}) async {
    return await deleteItem(_foodRepository.deleteFood(idFood: foodID));
  }

  Future<FirebaseResult<bool>> updateFood({required Food food}) async {
    return await updateItem(
        _foodRepository.updateFood(foodID: food.id, data: food.toJson()));
  }
}
