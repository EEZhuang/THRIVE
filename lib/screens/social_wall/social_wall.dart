import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/screens/social_wall/social_list.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:http/http.dart' as http;
import 'dart:convert';

// "User home page", screen useer sees after successful login
class SocialWall extends StatefulWidget {
  final FirebaseUser currUser;
  SocialWall({this.currUser});
  @override
  _SocialWallState createState() => _SocialWallState();
}

// TODO: add form key validation
class _SocialWallState extends State<SocialWall> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  String goal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thrive Wall", style: ThriveFonts.HEADING),
        centerTitle: true,
        backgroundColor: ThriveColors.DARK_GREEN,
      ),
      body: SocialList(currUser: widget.currUser),
      //backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      backgroundColor: ThriveColors.DARK_GRAY,
      // Button to signout and return to signin page
    );
  }
}
