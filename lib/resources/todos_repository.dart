import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Todo.dart';

class TodosRepository {
  FirebaseUser _user;
  DocumentReference _documentReference;

  
  Future<List<Todo>> loadTodos() async {
    if(this._user == null) {
      this._user = await FirebaseAuth.instance.currentUser();
    }

    _documentReference = Firestore.instance.collection("USERS").document(_user.uid);
    QuerySnapshot querySnapshot = await _documentReference.collection('Todos').where("deleted", isEqualTo: false).getDocuments();
    final _todos = querySnapshot.documents.map((snapshot) {
      return Todo(
        snapshot['title'], 
        snapshot['category'], 
        id: snapshot.documentID, 
        completed: snapshot['completed'],
        note: snapshot['note'],
        completeDate: snapshot['completeDate'] is Timestamp ? (snapshot['completeDate'] as Timestamp).toDate() : null,
        createdDate: snapshot['createdDate'] is Timestamp ? (snapshot['createdDate'] as Timestamp).toDate() : null
      );
    }).toList();
    // print("todos => ");
    // print(_todos);
    return _todos;
  }

  Future<String> addTodo(todo) async {
    if(this._user == null) {
      this._user = await FirebaseAuth.instance.currentUser();
    }
    final DocumentReference doc =  Firestore.instance.collection("USERS").document(_user.uid).collection('Todos').document();
    
    var todoId;

    await doc
    .setData(todo)
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