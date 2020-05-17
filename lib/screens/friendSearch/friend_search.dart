import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// "User home page", screen useer sees after successful login
class Search extends StatefulWidget {
  final Function toggleState;
  Search({this.toggleState});
  @override
  _SearchState createState() => _SearchState();
}

//
class _SearchState extends State<Search> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(),
        ),
      ),
    );
  }
}
