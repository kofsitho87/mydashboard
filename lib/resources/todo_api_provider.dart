// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'dart:convert';
// import '../models/Todo.dart';


// class TodoApiProvider {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<TodosModel> fetchTodoList() async {
//     print("api call start and return todo model");

//     final FirebaseUser user = await _auth.currentUser();

//     final uid = user.uid;
//     final DocumentReference documentReference = Firestore.instance.collection("USERS").document(uid);

//     if( true ){
//       QuerySnapshot querySnapshot = await documentReference.collection('Todos').getDocuments();
//       return TodosModel.fromJson( querySnapshot.documents );

//       // Iterable jsonParsed = json.decode("[{\"uid\": \"uid1\",\"title\": \"청소하기\"}]");
//       // return TodosModel.fromJson( jsonParsed );
//     }else {
//       throw Exception('Failed to load Todo data');
//     }

//     // final response = await client
//     //     .get("http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey");
//     // print(response.body.toString());
//     // if (response.statusCode == 200) {
//     //   // If the call to the server was successful, parse the JSON
//     //   return ItemModel.fromJson(json.decode(response.body));
//     // } else {
//     //   // If that call was not successful, throw an error.
//     //   throw Exception('Failed to load post');
//     // }
//   }

//   Future<TodosModel> add() async {
//     return TodosModel.add();
//   }
// }