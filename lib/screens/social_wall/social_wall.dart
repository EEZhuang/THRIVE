import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/screens/social_wall/social_list.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// "User home page", screen useer sees after successful login
class SocialWall extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  SocialWall({this.toggleHome, this.toggleState});
  @override
  _SocialWallState createState() => _SocialWallState();
}

// TODO: add form key validation
class _SocialWallState extends State<SocialWall> {
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
        title: Text("Thrive Wall"),
      ),
      body: social_list(),
      // Button to signout and return to signin page
      /**
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          widget.toggleHome();
          //print(_auth.getCurrentUser());
        },
      ),
          **/
    );
  }
}
