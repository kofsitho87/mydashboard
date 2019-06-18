import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
abstract class CategoriesBlocEvent extends Equatable {
  CategoriesBlocEvent([List props = const []]) : super(props);
}

class LoadCategories extends CategoriesBlocEvent {
  @override
  String toString() => 'LoadCategories';
}

class AddCategory extends CategoriesBlocEvent {
  final Category category;
  AddCategory(this.category);

  @override
  String toString() => 'AddCategory';
}

class UpdatedCategory extends CategoriesBlocEvent {
  final Category category;
  UpdatedCategory(this.category);

  @override
  String toString() => 'UpdatedCategory';
}

class DeleteCategory extends CategoriesBlocEvent {
  final Category category;
  DeleteCategory(this.category);

  @override
  String toString() => 'DeleteCategory';
}

class AddTodo extends CategoriesBlocEvent {
  final Category currentCategory;
  final Todo todo;

  AddTodo(this.currentCategory, this.todo) : super([currentCategory, todo]);

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdatedTodo extends CategoriesBlocEvent {
  final Category currentCategory;
  final Todo updatedTodo;
  UpdatedTodo(this.currentCategory, this.updatedTodo) : super([currentCategory, updatedTodo]);

  @override
  String toString() => 'UpdateTodo';
}

class DeleteTodo extends CategoriesBlocEvent {
  final Category currentCategory;
  final Todo todo;
  DeleteTodo(this.currentCategory, this.todo) : super([currentCategory, todo]);

  @override
  String toString() => 'DeleteTodo';
}