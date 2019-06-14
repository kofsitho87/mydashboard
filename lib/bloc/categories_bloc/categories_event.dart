import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoriesBlocEvent extends Equatable {
  CategoriesBlocEvent([List props = const []]) : super(props);
}

class LoadCategories extends CategoriesBlocEvent {
  @override
  String toString() => 'LoadCategories';
}