//import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/screens/home/home.dart';
import 'package:thrive/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';

// Handles which screen to show based on status of current user
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  AuthService _auth = AuthService();
  FirebaseUser currUser;
  int currState = 0;
  bool showHome = false;

  // Grabs current user logged into system
  Future getCurrentUser() async {
    FirebaseUser user = await _auth.getCurrentUser();
    currUser = user;
    print("getCurrUser finished");
  }

  //Fires state change
  void toggleHome(int state) {
    setState(() {
      showHome = !showHome;
    });
  }

  //new state change
  void toggleState(int state) {
    setState(() {
      currState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getCurrentUser(),
        builder: (context, snapshot) {

          // Shows home if current user is logged in
          // Shows login page otherwise
          if (currUser != null) {
            return Home(toggleHome: toggleHome);
          } else {
            return Authenticate(toggleHome: toggleHome);
          }
    });
  }
}
