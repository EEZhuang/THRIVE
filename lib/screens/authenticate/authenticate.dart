import 'package:flutter/material.dart';
import 'package:thrive/screens/authenticate/register.dart';
import 'package:thrive/screens/authenticate/sign_in.dart';

// Handles which of Register/Login screen to show
class Authenticate extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Authenticate({this.toggleHome, this.toggleState});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {


  bool showSignIn = true;

  // Called by buttons within SignIn/Register to fire state change
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return SignIn(toggleView: toggleView, toggleHome: widget.toggleHome, toggleState: widget.toggleState);
    } else {
      return Register(toggleView: toggleView, toggleHome: widget.toggleHome, toggleState: widget.toggleState);
    }
  }
}

