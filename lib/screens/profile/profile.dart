import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_goal_list.dart';

// "User home page", screen useer sees after successful login
class Profile extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  final FirebaseUser currUser;
  Profile({this.toggleHome, this.toggleState, this.currUser});
  @override
  _ProfileState createState() => _ProfileState();
}

// TODO: add form key validation
class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  String goal = '';

  // Makes HTTP request passing uid and goal in body
  void postUserGoal(String uid, String goal) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/goals',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'goal': goal,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: GoalList(currUser: widget.currUser),

      // Button to signout and return to signin page
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          widget.toggleHome();
          //print(_auth.getCurrentUser());
        },
      ),
    );
  }
}
