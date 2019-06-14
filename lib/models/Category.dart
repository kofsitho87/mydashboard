import 'package:cloud_firestore/cloud_firestore.dart';
import './Todo.dart';

class Category {
  String uid;
  String title;

  DocumentReference ref;
  String color;
  List<Todo> todos;

  Category(this.uid, this.title, {this.ref, this.color, this.todos = const []});
}