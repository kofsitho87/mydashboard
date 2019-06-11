import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/file_stroage.dart';
import '../models/models.dart';

class Repository {
  final FileStorage fileStorage;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Repository({@required this.fileStorage});

  //final authApiProvidr = AuthApiProvider();


  //Future<User> loadUser() => authApiProvidr.loadUser();
  //Future<User> login() => authApiProvidr.login();

  Future<User> loadUser() async {
    try {
      return await fileStorage.loadUser();
    } catch (e) {
      throw e;
    }
  }

  Future<User> login(email, password) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if( user == null ){
        user = await _auth.signInWithEmailAndPassword(email: email, password: password);  
      }
      final userModel = User(user.uid, user.displayName, user.email);
      var a= this.saveUser(userModel);
      a.then((file) {
        print(file.toString());
      });
      return userModel;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signOut() async {
    try {
      _auth.signOut();
      await fileStorage.clean();
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> signUp(email, userName, password) async {
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final userUpdate = UserUpdateInfo();
      userUpdate.displayName = userName;
      
      await user.updateProfile( userUpdate );

      final data = {
        "uid": user.uid,
        "name": userName,
        "email": user.email
      };
      Firestore.instance.collection("USERS").document(user.uid).setData(data);

      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<File> saveUser(User user) async {
    try {
      return await fileStorage.saveUser(user);
    } catch (e) {
      throw e;
    }
  }
}