import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive/formats/colors.dart' as ThriveColors;

// "User home page", screen useer sees after successful login
class ChangePass extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  ChangePass({this.toggleHome, this.toggleState});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();

}


class _ChangePasswordState extends State<ChangePass> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  //text field state
  String password1 = '';
  String password2 = '';
  String error = '';

  bool loading = false;

  // Indicated which screen is selected
  int _selectedIndex = 1;

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

    // Redirects to different screen.
    if (_selectedIndex == 0) {
      widget.toggleState(1);
    } else if (_selectedIndex == 1) {

    } else if (_selectedIndex == 2) {

    } else if (_selectedIndex == 3) {

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password", style: TextStyle(fontFamily: 'Proxima', fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        backgroundColor: Color(0xFF69A297),
      ),
      backgroundColor: Color(0xF0080F0F),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:textInputDecoration.copyWith(hintText:  'Enter new password'),
                    onChanged: (val) {
                      setState(() {
                        password1 = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:textInputDecoration.copyWith(hintText:  'Confirm new password'),
                    onChanged: (val2) {
                      setState(() {
                        password2 = val2;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: ThriveColors.WHITE,
                    child: Text('Change Password'),
                    onPressed: () async {

                      // TODO: pass user as parameter from Wrapper()
                      FirebaseUser user = await _auth.getCurrentUser();

                      // If there is a current user logged in, make HTTP request
                      if(password1 == password2) {
                        user.updatePassword(password1).then((_){
                          print("Successfully changed password");
                        }).catchError((error){
                          print("Password cannot be changed" + error.toString());
                          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                        });
                      }

                    },
                  ),
                  SizedBox(height: 12.0),
                  Text( error, style: TextStyle(color: Colors.red) ),
                ])),
      ),
      // Bottom Navigation Bar
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text('Add Goal'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),*/
    );
  }
}
