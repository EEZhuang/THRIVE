import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Search({this.toggleHome, this.toggleState});

  @override
  _SearchState createState() => _SearchState();
}

// Screen for searching friends
class _SearchState extends State<Search> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //String
  String query = '';

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  // condition to search for uid for each user
  // TODO: first need to add users to database
  controlSearching(String str) {
    Future<QuerySnapshot> allUsers;
    setState(() {
      futureSearchResults = allUsers;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      title: TextFormField(
        style: TextStyle(fontSize: 18.0),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.person_pin,
            color: Colors.black,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: emptyTheTextFormField,
          ),
        ),
        //onFieldSubmitted: controlSearching,
      ),
    );
  }

  Container displayNoSearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.group,
              color: Colors.grey,
              size: 200.0,
            ),
            Text(
              "Search Users,",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 65.0),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: depends on database
  displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: futureSearchResults == null
          ? displayNoSearchResultsScreen()
          : displayUsersFoundScreen(),
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

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => print("tapped"), // TODO: profile page can go here
            ),
          ],
        ),
      ),
    );
  }
}
