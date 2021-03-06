import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

@immutable
abstract class FilteredTodosEvent extends Equatable {
  FilteredTodosEvent([List props = const []]) : super(props);
}

class UpdateFilter extends FilteredTodosEvent {
  final Category currentCategory;
  final VisibilityFilter filter;

  UpdateFilter(this.currentCategory, this.filter) : super([currentCategory, filter]);

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateTodos extends FilteredTodosEvent {
  final List<Todo> todos;

  UpdateTodos(this.todos) : super([todos]);

  @override
  String toString() => 'UpdateTodos { todos: $todos }';
}

class SortingTodos extends FilteredTodosEvent {
  final SortingFilter filter;

  SortingTodos(this.filter) : super([filter]);

  @override
  String toString() => 'SortTodos';
}

class VisibilityTodos extends FilteredTodosEvent {
  final VisibilityFilter filter;

  VisibilityTodos(this.filter) : super([filter]);

  @override
  String toString() => 'VisibilityTodos';
}
