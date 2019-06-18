import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

import '../../resources/todos_repository.dart';
import '../../models/models.dart';

class CategoriesBloc extends Bloc<CategoriesBlocEvent, CategoriesBlocState> {
  final TodosRepository todosRepository;
  CategoriesBloc({this.todosRepository});

  @override
  CategoriesBlocState get initialState => CategoriesLoading();

  @override
  Stream<CategoriesBlocState> mapEventToState(
    CategoriesBlocEvent event,
  ) async* {
    if (event is LoadCategories) {
      yield* _mapLoadCategoriesToState();
    }else if (event is AddCategory){
      yield* _mapAddCategoryToState(event);
    }else if (event is AddTodo){
      yield* _mapAddTodoToState(event);
    }else if (event is UpdatedTodo){
      yield* _mapUpdateTodoToState(event);
    }else if (event is DeleteTodo){
      yield* _mapDeleteTodoToState(event);
    }else if (event is DeleteCategory){
      yield* _mapDeleteCategoryToState(event);
    }else if (event is UpdatedCategory){
      yield* _mapUpdateCategoryToState(event);
    }
  }

  Stream<CategoriesBlocState> _mapLoadCategoriesToState() async* {
    try {
      final categories = await this.todosRepository.loadCategories();
      yield CategoriesLoaded(categories);
    } catch (e) {
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapAddCategoryToState(AddCategory event) async* {
    try {
      final categories = (currentState as CategoriesLoaded).categories;
      final categoryId = await this.todosRepository.addCategory(event.category);
      event.category.uid = categoryId;
      yield CategoriesLoading();
      final List<Category> updatedCategories = List.from(categories)..add(event.category);
      yield SuccessAddCategory();
      yield CategoriesLoaded(updatedCategories);
    } catch (e) {
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapUpdateCategoryToState(UpdatedCategory event) async* {
    try {
      final categories = (currentState as CategoriesLoaded).categories;
      await this.todosRepository.updateCategory(event.category);
      yield CategoriesLoading();
      final updatedCategories = categories.map((cate) {
        return cate.uid == event.category.uid ? event.category : cate;
      }).toList();
      yield SuccessAddCategory();
      yield CategoriesLoaded(updatedCategories);
    } catch (e) {
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapAddTodoToState(AddTodo event) async* {
    try {
      final categories = (currentState as CategoriesLoaded).categories;
      yield TodosLoading();
      final todoId = await this.todosRepository.addTodo(event.todo);
      final todo = event.todo;
      todo.id = todoId;
      event.currentCategory.todos.add(todo);

      
      // final List<Category> updatedCategories = List.from(categories)..add(event.category);
      yield SuccessAddTodo();
      yield CategoriesLoaded(categories);
    } catch (e) {
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapUpdateTodoToState(UpdatedTodo event) async* {
    
    try {
      final categories = (currentState as CategoriesLoaded).categories;

      yield TodosLoading();
      await this.todosRepository.updateTodo(event.updatedTodo);

      

      if(event.updatedTodo.category == event.currentCategory){
        final List<Todo> updatedTodos = event.currentCategory.todos.map((todo) {
          return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
        })
        .where((todo) => todo.deleted == false)
        .toList();
        event.currentCategory.todos = updatedTodos;

        final List<Category> updatedCategories = categories.map((cate) {
          return cate.uid == event.currentCategory.uid ? event.currentCategory : cate;
        }).toList(); 

        yield SuccessUpdateTodo();
        yield CategoriesLoaded(updatedCategories);
      }else {
        final List<Todo> prevCategoryupdatedTodos = event.currentCategory.todos.where((todo) {
          return todo.id != event.updatedTodo.id;
        }).toList();
        event.currentCategory.todos = prevCategoryupdatedTodos;

        final currentCategory = categories.firstWhere((cate) => cate.uid == event.updatedTodo.category.uid);
        currentCategory.todos.add( event.updatedTodo );

        final List<Category> updatedCategories = categories.map((cate) {
          return cate.uid == event.currentCategory.uid ? event.currentCategory : (cate.uid == currentCategory.uid ? currentCategory : cate);
        }).toList(); 

        yield SuccessUpdateTodo();
        yield CategoriesLoaded(updatedCategories);
      }
      
    } catch (e) {
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapDeleteTodoToState(DeleteTodo event) async* {
    // event.todo.deleted = true;
    // yield* _mapUpdateTodoToState(UpdatedTodo(event.currentCategory, event.todo));

    try {
      final categories = (currentState as CategoriesLoaded).categories;
      yield TodosLoading();
      
      final todo = event.todo;
      // todo.deleted = true;
      await this.todosRepository.deleteTodo(todo);
      final updatedTodos = //(currentState as TodosLoaded)
        event.currentCategory.todos
        .where((todo) => todo.id != event.todo.id)
        .toList();

      event.currentCategory.todos = updatedTodos;

      final List<Category> updatedCategories = categories.map((cate) {
        return cate.uid == event.currentCategory.uid ? event.currentCategory : cate;
      }).toList();

      yield SuccessDeleteTodo();
      yield CategoriesLoaded(updatedCategories);

    }catch(e){
      yield FailCategoriesLoaded(e.toString());
    }
  }

  Stream<CategoriesBlocState> _mapDeleteCategoryToState(DeleteCategory event) async* {
    // event.todo.deleted = true;
    // yield* _mapUpdateTodoToState(UpdatedTodo(event.currentCategory, event.todo));

    try {
      final categories = (currentState as CategoriesLoaded).categories;
      yield CategoriesLoading();
      
      event.category.todos.forEach((todo) async {
        await this.todosRepository.deleteTodo(todo);
      });
      await this.todosRepository.deleteCategory(event.category);

      final updatedCategories = categories.where((cate) => cate.uid != event.category.uid).toList();
      yield CategoriesLoaded(updatedCategories);

    }catch(e){
      yield FailCategoriesLoaded(e.toString());
    }
  }

}

