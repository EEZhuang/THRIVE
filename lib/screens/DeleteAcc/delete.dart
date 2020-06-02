import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/screens/wrapper.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/shared/constants.dart';
import 'package:thrive/screens/authenticate/sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive/formats/colors.dart' as ThriveColors;

// "User home page", screen user sees after successful login
class Delete extends StatefulWidget {
  final Function toggleHome;
  Delete({this.toggleHome});
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
        title: Text("Delete Account",
            style: TextStyle(
                fontFamily: 'Proxima',
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        centerTitle: true,
        backgroundColor: Color(0xFF69A297),
      ),
      backgroundColor: ThriveColors.DARK_GRAY,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'Enter email'),
                onChanged: (val1) {
                  setState(() {
                    email = val1;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'Enter password'),
                onChanged: (val2) {
                  setState(() {
                    password = val2;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: ThriveColors.WHITE,
                child: Text('Delete Account'),
                onPressed: () async {
                  FirebaseUser user = await _auth.getCurrentUser();
                  if (user != null) {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = 'Credentials do not match, try again';
                        });
                      } else {
                        FirebaseUser user2 = await _auth.getCurrentUser();
                        if (user2.uid == user.uid) {
                          await user.delete();
                          //widget.toggleHome();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                          //widget.toggleHome();
                          //Navigator.of(context).pop(false);
                          //await user.delete();
                          //widget.toggleHome();
                          //user.delete();
                          //await _auth.signOut();
                        } else {
                          error = 'Credentials do not match, try again';
                        }
                      }
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red)),
            ])),
      ),
    );
  }
}
