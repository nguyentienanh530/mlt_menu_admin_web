part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoriesFetched extends CategoryEvent {}

class CategoryCreated extends CategoryEvent {
  final CategoryModel categoryModel;

  const CategoryCreated({required this.categoryModel});
}

class CategoryUpdated extends CategoryEvent {
  final CategoryModel categoryModel;

  const CategoryUpdated({required this.categoryModel});
}

class CategoryDeleted extends CategoryEvent {
  final CategoryModel categoryModel;

  const CategoryDeleted({required this.categoryModel});
}
