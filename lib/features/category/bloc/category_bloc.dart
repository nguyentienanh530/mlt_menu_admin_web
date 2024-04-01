import 'dart:async';

import 'package:mlt_menu_admin_web/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/features/category/data/provider/remote/category_repo.dart';
import 'package:category_repository/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/category_model.dart';
part 'category_event.dart';

typedef Emit = Emitter<GenericBlocState<CategoryModel>>;

class CategoryBloc extends Bloc<CategoryEvent, GenericBlocState<CategoryModel>>
    with BlocHelper<CategoryModel> {
  CategoryBloc() : super(GenericBlocState.loading()) {
    on<CategoriesFetched>(_fetchCategories);
    on<CategoryCreated>(_createCategory);
    on<CategoryUpdated>(_updateCategory);
    on<CategoryDeleted>(_deleteCategory);
  }
  final _categoryRepo = CategoryRepo(
      categoryRepository:
          CategoryRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _fetchCategories(CategoriesFetched event, Emit emit) async {
    await getItems(_categoryRepo.getCategories(), emit);
  }

  FutureOr<void> _createCategory(CategoryCreated event, Emit emit) async {
    await createItem(
        _categoryRepo.createCategory(categoryModel: event.categoryModel), emit);
  }

  FutureOr<void> _updateCategory(CategoryUpdated event, Emit emit) async {
    await updateItem(
        _categoryRepo.updateCategory(categoryModel: event.categoryModel), emit);
  }

  FutureOr<void> _deleteCategory(CategoryDeleted event, Emit emit) async {
    await deleteItem(
        _categoryRepo.deleteCategory(categoryModel: event.categoryModel), emit);
  }
}
