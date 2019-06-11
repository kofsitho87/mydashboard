import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

import '../../models/models.dart';
import '../todo_bloc/bloc.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.state.listen((state) {
      if (state is TodosLoaded) {
        final todos = (todosBloc.currentState as TodosLoaded).todos;
        dispatch(UpdateTodos(todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState {
    if( todosBloc.currentState is TodosLoaded ){
      return FilteredTodosLoaded((todosBloc.currentState as TodosLoaded).todos, VisibilityFilter.all);
    }
    return FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(
    FilteredTodosEvent event,
  ) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateTodos) {
      yield* _mapTodosUpdatedToState(event);
    } else if (event is SortingTodos) {
      yield* _mapSoltingTodosToState(event);
    } else if (event is VisibilityTodos) {
      yield* _mapVisiblilityTodosToState(event);
    }
  }

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    if (todosBloc.currentState is TodosLoaded) {
      yield FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (todosBloc.currentState as TodosLoaded).todos,
          event.filter,
        ),
        event.filter
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    UpdateTodos event,
  ) async* {
    
    final visibilityFilter = currentState is FilteredTodosLoaded 
      ? (currentState as FilteredTodosLoaded).activeFilter
      : VisibilityFilter.all;
    
    print('visibilityFilter : $visibilityFilter');

    yield FilteredTodosLoading();

    final todos = _mapTodosToFilteredTodos(
      (todosBloc.currentState as TodosLoaded).todos,
      visibilityFilter,
    );

    yield FilteredTodosLoaded(todos, visibilityFilter);
  }

  List<Todo> _mapTodosToFilteredTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.completed;
      } else if (filter == VisibilityFilter.completed) {
        return todo.completed;
      }
    }).toList();
  }

  Stream<FilteredTodosState> _mapSoltingTodosToState(SortingTodos event) async* {
    final todos = (todosBloc.currentState as TodosLoaded).todos;
    yield FilteredTodosLoading();

    if (event.filter == SortingFilter.basic) {
      todos.sort((a, b) {
        return a.createdDate.compareTo(b.createdDate);
      });
    }else if( event.filter == SortingFilter.completeDate ){
      final defaultDate = DateTime.parse('2999-01-01 00:00:00Z');
      todos.sort((a, b) {
        // if( a.completeDate == null && b.completeDate == null ) {
        //   return 1;
        // }
        final currentCompleteDate = a.completeDate == null ? defaultDate : a.completeDate;
        final nextCompleteDate = b.completeDate == null ? defaultDate : b.completeDate;
        return currentCompleteDate.compareTo(nextCompleteDate);
      });
    }else if(event.filter == SortingFilter.activeCompleted) {
      todos.sort((a, b) {
        return a.completed ? 1 : 0;
      });
    }
    yield FilteredTodosLoaded(todos, VisibilityFilter.all);
  }

  Stream<FilteredTodosState> _mapVisiblilityTodosToState(VisibilityTodos event) async* {
    var todos = (todosBloc.currentState as TodosLoaded).todos;
    yield FilteredTodosLoading();

    if (event.filter == VisibilityFilter.completed) {
      todos = todos.where((todo) {
        return todo.completed;
      }).toList();
    }else if( event.filter == VisibilityFilter.active ){
      todos = todos.where((todo) {
        return todo.completed == false;
      }).toList();
    }
    yield FilteredTodosLoaded(todos, event.filter);
  }

  @override
  void dispose() {
    todosSubscription.cancel();
    super.dispose();
  }
}
