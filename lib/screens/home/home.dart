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

  // Indicated which screen is selected
  int _selectedIndex = 0;

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

    } else if (_selectedIndex == 1) {

    } else if (_selectedIndex == 2) {

    } else if (_selectedIndex == 3) {

    }
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
            ),


          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
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
