import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';



@immutable
abstract class TodosState extends Equatable {
  TodosState([List props = const []]) : super(props);
}

class TodosLoading extends TodosState {
  @override
  String toString() => 'TodosLoading';
}

class TodosLoaded extends TodosState {
  //final SortingFilter activeFilter;
  final List<Category> categories;
  final List<Todo> todos;

  TodosLoaded([this.todos = const [], this.categories = const []]) : super([todos, categories]);

  @override
  String toString() => 'TodosLoaded $categories';
}

class TodosNotLoaded extends TodosState {
  @override
  String toString() => 'TodosNotLoaded';
}