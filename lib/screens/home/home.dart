import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// "User home page", screen useer sees after successful login
class Home extends StatefulWidget {
  final Function toggleHome;
  Home({this.toggleHome});
  @override
  _HomeState createState() => _HomeState();

}

//TODO: use numerical values to indicate screen
// TODO: add form key validation

class _HomeState extends State<Home> {
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
        title: Text("Thrive Test"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 20.0
            ),
            TextFormField(
              onChanged: (val) {
                setState(() {
                  goal = val;
                });
              },

            ),
            RaisedButton(
              child: Text('submit goal'),
              onPressed: () async {

                // TODO: pass user as parameter from Wrapper()
                FirebaseUser result = await _auth.getCurrentUser();

                // If there is a current user logged in, make HTTP request
                if (result != null){
                  print(result.uid);
                  postUserGoal(result.uid, goal);
                }
                print(goal);

              },
            )

          ],
        ),
      ),


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
