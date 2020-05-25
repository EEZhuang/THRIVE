import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/models/user.dart';
import 'package:flutter/material.dart';


// Handles all user authentication methods such that no direct Auth calls are
// made from thee screens
class AuthService{



  final FirebaseAuth _auth = FirebaseAuth.instance;
  //FirebaseUser currUser = null;

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));

  }


  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //currUser = user;
      //print('here1');
      return user;
    } catch(error){
      //print('here2');
      print(error.toString());
      //print('here3');
      return null;
    }
  }

  //Retrieve the current user
  Future getCurrentUser() async{
    dynamic user =  await _auth.currentUser();
    if (user != null){
      return user;
    }
    //print("null object");
    return null;
  }


  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
      //create a new document for the specific uid
      //await DatabaseService(uid: user.uid).updateUserData('undefined goal', email, "0");
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      //currUser = null;
      return await _auth.signOut();

    } catch(e){
      print(e.toString());
      return null;
    }
  }
}