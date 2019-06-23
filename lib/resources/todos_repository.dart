import 'dart:async';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mydashboard/models/models.dart';

import '../models/Todo.dart';
import '../resources/file_stroage.dart';

class TodosRepository {
  final FileStorage fileStorage;
  TodosRepository({@required this.fileStorage});

  FirebaseUser _user;
  DocumentReference _documentReference;

  Future<void> updateCategory(Category category) async {
    final doc = _documentReference.collection('Categories').document(category.uid);
    return doc.setData(category.toMap());
  }

  Future<String> addCategory(Category category) async {
    final doc = _documentReference.collection('Categories').document();
    var categoryId;
    await doc.setData(category.toMap())
    .whenComplete(() {
      //print('Document Added');
      categoryId = doc.documentID;
    }).catchError((e) {
      print(e);
    });

    return categoryId;
  }

  Future<void> deleteCategory(Category category) async {
    final doc = _documentReference.collection('Categories').document(category.uid);
    return doc.delete();
  }

  Future<List<Category>> loadCategories() async {
    if(this._user == null) {
      this._user = await FirebaseAuth.instance.currentUser();
    }

    List<Category> categories = [];

    _documentReference = Firestore.instance.collection("USERS").document(_user.uid);
    QuerySnapshot querySnapshot = await _documentReference.collection('Categories').getDocuments();
    for(var cateSnapshot in querySnapshot.documents) {
      final cate = Category(
        cateSnapshot.documentID,
        cateSnapshot['title'],
        ref: cateSnapshot.reference
      );
      final todosSnapshot = await _documentReference.collection('Todos').where('category', isEqualTo: cateSnapshot.reference).getDocuments();
      final todos = todosSnapshot.documents.map((snapshot) {
        return Todo(
          snapshot['title'], 
          cate, //cateSnapshot['title'], 
          id: snapshot.documentID, 
          completed: snapshot['completed'],
          note: snapshot['note'],
          completeDate: snapshot['completeDate'] is Timestamp ? (snapshot['completeDate'] as Timestamp).toDate() : null,
          createdDate: snapshot['createdDate'] is Timestamp ? (snapshot['createdDate'] as Timestamp).toDate() : null,
          important: snapshot['important'],
        );
      }).toList();
      cate.todos = todos;
      categories.add(cate);
    };
    return categories.toList();
  }




  Future<VisibilityFilter> loadTodosFilter() async {
    try {
      final filter = await fileStorage.loadTodosFilter();
      switch(filter){
        case 'VisibilityFilter.all':
          return VisibilityFilter.all;
          break;

        case 'VisibilityFilter.active':
          return VisibilityFilter.active;
          break;

        case 'VisibilityFilter.completed':
          return VisibilityFilter.completed;
          break;
      }
      return VisibilityFilter.all;
    } catch(e) {
      return VisibilityFilter.all;
      //throw e;
    }
  }

  Future<bool> saveTodosFilter(VisibilityFilter filter) async {
    try {
      print('필터저장');
      await fileStorage.saveTodosFilter(filter.toString());
      return true;
    } catch (e) {
      throw e;
      //return false;
    }
  }
  
  Future<List<Todo>> loadTodos() async {
    if(this._user == null) {
      this._user = await FirebaseAuth.instance.currentUser();
    }
    _documentReference = Firestore.instance.collection("USERS").document(_user.uid);
    QuerySnapshot querySnapshot = await _documentReference.collection('Todos').where("deleted", isEqualTo: false).getDocuments();
    final _todos = querySnapshot.documents.map((snapshot) {
      return Todo(
        snapshot['title'], 
        Category('', ''), //snapshot['category'], 
        id: snapshot.documentID, 
        completed: snapshot['completed'],
        note: snapshot['note'],
        completeDate: snapshot['completeDate'] is Timestamp ? (snapshot['completeDate'] as Timestamp).toDate() : null,
        createdDate: snapshot['createdDate'] is Timestamp ? (snapshot['createdDate'] as Timestamp).toDate() : null
      );
    }).toList();
    return _todos;
  }

  Future<String> addTodo(Todo todo) async {
    if(this._user == null) {
      this._user = await FirebaseAuth.instance.currentUser();
    }
    final DocumentReference doc =  Firestore.instance.collection("USERS").document(_user.uid).collection('Todos').document();
    
    var todoId;

    await doc
    .setData(todo.toMap())
    .whenComplete(() {
      print('Document Added');
      todoId = doc.documentID;
    }).catchError((e) {
      print(e);
    });

    return todoId;
  }

  Future<bool> deleteTodo(Todo todo) async {
    var result = false;
    await Firestore.instance.collection("USERS").document(_user.uid)
        .collection('Todos')
        .document(todo.id)
        .delete()
        .whenComplete(() {
          result = true;
          print('deleted'); 
        }
    ).catchError((e) {
      print(e);
    });
    return result;
  }

  Future<bool> updateTodo(Todo todo) async {
    var result = false;
    await Firestore.instance.collection("USERS").document(_user.uid)
        .collection('Todos')
        .document(todo.id)
        .updateData(todo.toMap())
        .whenComplete(() {
          result = true;
          print('updated');
        })
    .catchError((e) {
      print(e);
    });
    return result;
  }
  
  Future saveTodos(List<Todo> todos) {
    // Map<String, dynamic> data = {
    //   "title": title,
    //   'completed': false,
    //   'category': category,
    //   'completeDate': completeDate,
    //   'timestamp': DateTime.now()
    // };
    // if(this._user == null) {
    //   this._user = await FirebaseAuth.instance.currentUser();
    // }
    // final DocumentReference doc =  Firestore.instance.collection("USERS").document(_user.uid).collection('Todos').document();
    // await doc
    // .setData(data)
    // .whenComplete(() {
    //   print('Document Added');
      
    // }).catchError((e) {
    //   print(e);
      
    // });
    
    // return Future.wait<dynamic>([
    //   fileStorage.saveTodos(todos),
    //   webClient.postTodos(todos),
    // ]);
  }
}