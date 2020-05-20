import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/screens/createGoal/createGoal.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thrive/services/database.dart';

// "User home page", screen user sees after successful login

class Home extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Home({this.toggleHome, this.toggleState});
  @override
  _HomeState createState() => _HomeState();
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wall Placeholder"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text('Goal'),
          subtitle: Text('$index'),
        );
      }),
    );
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();

  //String
  String goal = '';
  String goalID = '';

  // Indicated which screen is selected
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    /*
    // Redirects to different screen.
    if (_selectedIndex == 0) {
    } else if (_selectedIndex == 1) {
      widget.toggleState(2);
    } else if (_selectedIndex == 2) {
      // Ethan
      widget.toggleState(3);

      // Vas
      widget.toggleState(3);
      
      // Ed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateGoal()),
      );

    } else if (_selectedIndex == 3) {
      widget.toggleState(4);
    }

     */
  }

  /*
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goal Input Tester"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              onChanged: (val) {
                setState(() {
                  goal = val;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(onChanged: (val) {
              setState(() {
                goalID = val;
              });
            }),
            RaisedButton(
              child: Text('submit goal'),
              onPressed: () async {
                // TODO: pass user as parameter from Wrapper()
                FirebaseUser result = await _auth.getCurrentUser();

                // If there is a current user logged in, make HTTP request
                if (result != null) {
                  print(result.uid);
                  _db.postUserGoal(result.uid, goal, goalID);
                }
                print(goal);
              },
            ),
          ],
        ),
      ),
    );
  }

}

//TODO: use numerical values to indicate screen
// TODO: add form key validation
class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  // Indicated which screen is selected
  int _selectedIndex = 0;

  final List<Widget> pages = [
    FirstPage(
      key: PageStorageKey('Page1'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("Thrive Test"),
      ),

       */
      body: PageStorage(
          child: pages[_selectedIndex],
          bucket: bucket,
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
        //onTap: (int index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
      ),

      // Button to signout and return to signin page
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          widget.toggleState(0);
          //print(_auth.getCurrentUser());
        },
      ),
    );
  }
}
