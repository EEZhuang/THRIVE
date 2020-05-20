import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// "User home page", screen user sees after successful login
class Delete extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Delete({this.toggleHome, this.toggleState});
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  //text field state
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  // Indicated which screen is selected
  int _selectedIndex = 2;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              onChanged: (val1) {
                setState(() {
                  email = val1;
                });
              },

            ),
            SizedBox(
                height: 20.0
            ),
            TextFormField(
              onChanged: (val2) {
                setState(() {
                  password = val2;
                });
              },
            ),
            RaisedButton(
              child: Text('Delete account'),
              onPressed: () async {
                // TODO: pass user as parameter from Wrapper()
                FirebaseUser user = await _auth.getCurrentUser();
        
                // If there is a current user logged in, make HTTP request
                /*
                if (result != null) {
                  print(result.uid);
                  postUserGoal(result.uid, goal);
                }
                print(goal);
              },
            ),
          ],
          */
                if (user != null) {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(
                        email, password);
                    //print("result here" + result);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = 'Credentials do not match, try again';
                      });
                    } else {
                      FirebaseUser user2 = await _auth.getCurrentUser();
                      if (user2.uid == user.uid) {
                        user.delete();
                        await _auth.signOut();
                      } else {
                        error = 'Credentials do not match, try again';
                      }
                    }
                  }
                }

              },
        ),
        SizedBox(height: 12.0),
        Text( error, style: TextStyle(color: Colors.red) ),
      ])),
 
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
