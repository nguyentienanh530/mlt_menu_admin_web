import 'package:mlt_menu_admin/common/firebase/firebase_base.dart';
import 'package:mlt_menu_admin/common/firebase/firebase_result.dart';
import 'package:mlt_menu_admin/features/category/data/model/category_model.dart';
import 'package:category_repository/category_repository.dart';

class CategoryRepo extends FirebaseBase<CategoryModel> {
  final CategoryRepository _categoryRepository;

  CategoryRepo({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  Future<FirebaseResult<List<CategoryModel>>> getCategories() async {
    return await getItems(
        await _categoryRepository.getCategories(), CategoryModel.fromJson);
  }

  Future<FirebaseResult<bool>> createCategory(
      {required CategoryModel categoryModel}) async {
    return await createItem(
        _categoryRepository.createCategory(categoryModel.toJson()));
  }

  Future<FirebaseResult<bool>> updateCategory(
      {required CategoryModel categoryModel}) async {
    return await updateItem(_categoryRepository.updateCategory(
        categoryID: categoryModel.id ?? '', data: categoryModel.toJson()));
  }

  Future<FirebaseResult<bool>> deleteCategory(
      {required CategoryModel categoryModel}) async {
    return await deleteItem(
        _categoryRepository.deleteCategory(categoryID: categoryModel.id ?? ''));
  }
}
