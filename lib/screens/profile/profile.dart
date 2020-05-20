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

//TODO: use numerical values to indicate screen
// TODO: add form key validation

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  String goal = '';

  // Indicated which screen is selected
  int _selectedIndex = 3;

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
      widget.toggleState(3);
    } else if (_selectedIndex == 3) {
      widget.toggleState(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: GoalList(currUser: widget.currUser),

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
