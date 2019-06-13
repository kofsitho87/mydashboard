import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

import '../../resources/todos_repository.dart';
import '../../models/models.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository todosRepository;
  TodosBloc({this.todosRepository});

  @override
  TodosState get initialState => TodosLoading();

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } 
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    try {
      final todos = await this.todosRepository.loadTodos();
      final categories = await this.todosRepository.loadCategories();
      yield TodosLoaded(todos, categories);
    } catch (e) {
      print("todos not loaded why??? ${e.toString()}");
      yield TodosNotLoaded();
    }
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    try {
      final todos = (currentState as TodosLoaded).todos;
      final categories = (currentState as TodosLoaded).categories;
      yield TodosLoading();
      final String todoId = await this.todosRepository.addTodo(event.todo.toMap());
      if(todoId != null) {
        final todo = event.todo;
        todo.id = todoId;
        final List<Todo> updatedTodos = List.from(todos)..add(todo);
        yield TodosLoaded(
          updatedTodos,
          categories
        );
      }else {
        throw('error');
      }
    } catch (_) {
      yield TodosNotLoaded();
    }
    // if (currentState is TodosLoaded) {
    //   final List<Todo> updatedTodos =
    //       List.from((currentState as TodosLoaded).todos)..add(event.todo);
    //   yield TodosLoaded(updatedTodos);
    //   _saveTodos(updatedTodos);
    // }
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    try {
      final todos = (currentState as TodosLoaded).todos;
      final categories = (currentState as TodosLoaded).categories;
      yield TodosLoading();
      final result = await this.todosRepository.updateTodo(event.updatedTodo);
      print(result);
      if(result) {
        final List<Todo> updatedTodos = todos.map((todo) {
          return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
        }).toList();
        yield TodosLoaded(updatedTodos, categories);
      }else {
        throw('error');
      }
    } catch (_) {
      yield TodosNotLoaded();
    }
    // if (currentState is TodosLoaded) {
    //   final List<Todo> updatedTodos =
    //       (currentState as TodosLoaded).todos.map((todo) {
    //     return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
    //   }).toList();
    //   yield TodosLoaded(updatedTodos);
    //   //_saveTodos(updatedTodos);
    // }
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final todos = (currentState as TodosLoaded).todos;
    final categories = (currentState as TodosLoaded).categories;
    yield TodosLoading();
    
    //final deleted = await this.todosRepository.deleteTodo(event.todo);
    final todo = event.todo;
    todo.deleted = true;
    final result = await this.todosRepository.updateTodo(todo);
    if( result ){
      final updatedTodos = //(currentState as TodosLoaded)
        todos
        .where((todo) => todo.id != event.todo.id)
        .toList();
      yield TodosLoaded(updatedTodos, categories);
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    if (currentState is TodosLoaded) {
      final allComplete =
          (currentState as TodosLoaded).todos.every((todo) => todo.completed);
      final List<Todo> updatedTodos = (currentState as TodosLoaded)
          .todos
          .map((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      yield TodosLoaded(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    if (currentState is TodosLoaded) {
      final List<Todo> updatedTodos = (currentState as TodosLoaded)
          .todos
          .where((todo) => !todo.completed)
          .toList();
      yield TodosLoaded(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Future _saveTodos(List<Todo> todos) {
    //return todosRepository.saveTodos(
      //todos.map((todo) => todo.toEntity()).toList(),
    //);
  }
}
