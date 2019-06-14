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
    }
  }

  Stream<CategoriesBlocState> _mapLoadCategoriesToState() async* {
    try {
      final categories = await this.todosRepository.loadCategories();
      yield CategoriesLoaded(categories);
    } catch (e) {
      //print("todos not loaded why??? ${e.toString()}");
      yield FailCategoriesLoaded(e.toString());
    }
  }
}
