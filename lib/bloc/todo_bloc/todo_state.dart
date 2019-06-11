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
  final SortingFilter activeFilter;
  final List<Todo> todos;

  TodosLoaded([this.todos = const [], this.activeFilter]) : super([todos, activeFilter]);

  @override
  String toString() => 'TodosLoaded { todos: $todos }';
}

class TodosNotLoaded extends TodosState {
  @override
  String toString() => 'TodosNotLoaded';
}


//class InitialTodoState extends TodoState {}