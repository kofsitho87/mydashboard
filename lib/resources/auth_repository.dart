import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../resources/file_stroage.dart';
import '../models/models.dart';

class AuthRepository {
  final FileStorage fileStorage;
  AuthRepository({@required this.fileStorage});

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

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
      _googleSignIn.signOut();
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
      await Firestore.instance.collection("USERS").document(user.uid).setData(data);

      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<User> googleSignin() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      

      final userModel = User(user.uid, user.displayName, user.email, provider: SnsProvider.google);

      final QuerySnapshot snapShot = await Firestore.instance.collection("USERS").where('uid', isEqualTo: user.uid).getDocuments();
      if( snapShot.documents.length < 1 ) {
        saveUserToFirebase(userModel);
      }
      
      // this.saveUser(userModel).then((file) {
      //   print('파일 저장 성공!!! ${file.toString()}');
      // });
      await this.saveUser(userModel);

      return userModel;
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

  saveUserToFirebase(User user) async {
    return Firestore.instance.collection("USERS").document(user.uid).setData(user.toJson());
  }
}