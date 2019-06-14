import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
abstract class CategoriesBlocState extends Equatable {
  CategoriesBlocState([List props = const []]) : super(props);
}

class CategoriesLoading extends CategoriesBlocState {
  @override
  String toString() => 'CategoriesLoading';
}

class CategoriesLoaded extends CategoriesBlocState {
  final List<Category> categories;
  CategoriesLoaded(this.categories) : super([categories]);

  @override
  String toString() => 'CategoriesLoaded';
}


class FailCategoriesLoaded extends CategoriesBlocState {
  final String error;
  FailCategoriesLoaded(this.error) : super([error]);
  
  @override
  String toString() => 'FailCategoriesLoaded';
}