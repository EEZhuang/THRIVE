import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/services/database.dart';

import 'FriendReturn.dart';

class Collaborators extends StatefulWidget {
  final FriendReturn collabs;
  Collaborators(this.collabs);

  @override
  _CreateCollabState createState() => _CreateCollabState(
      collabs.returnList, collabs.returnString, collabs.returnBool);
}

class _CreateCollabState extends State<Collaborators> {
  /*
  final List<Friend> friends = [
    Friend("Em"),
    Friend("Ethan"),
    Friend("Vas"),
    Friend("Riki"),
    Friend("Isabel"),
    Friend("Ishaan"),
    Friend("Aditya"),
    Friend("Edward"),
    Friend("Steven"),
    Friend("Sumi"),
    Friend("Gary"),
    Friend("Mark")
  ];

   */

  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  List<Friend> friends = [];
  List<String> friendList = [];

  String friendString;
  List<bool> friendToggle;

  _CreateCollabState(this.friendList, this.friendString, this.friendToggle);

  Future<List<String>> localFriendList() async{
    FirebaseUser result = await _auth.getCurrentUser();
    String username = await _db.getUsername(result.uid);
    //List<Tuple2<Goal, String>> wall = await _db.wallMap(username);
    //print("size:");
    //print("size:" + wall.length.toString());
    //Map<String, Goal> goalMap = await _db.getAllUserGoals(username);
    return await _db.getAllFriends(username);
  }

  Future<bool> _onWillPop() {
    FriendReturn fReturn =
        new FriendReturn(friendList, friendString, friendToggle);
    Navigator.pop(context, fReturn);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //backgroundColor: ThriveColors.TRANSPARENT_BLACK,
        backgroundColor: ThriveColors.DARK_GRAY,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThriveColors.DARK_GREEN,
          title: Text(
            "Add Collaborators",
            style: ThriveFonts.HEADING,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: this.localFriendList(),
          builder: (context, AsyncSnapshot snapshot) {
            List<String> friendsUsers = [];

            // Populate friends array
            if (snapshot.hasData) {
              friendsUsers = snapshot.data;

              // Add users to list of Friend objects
              for (var f in friendsUsers) {
                bool contains = false;

                // Check if friend is already in the list
                for (var friend in friends) {
                  if (friend.name == f) {
                    contains = true;
                  }
                }

                if (!contains) {
                  friends.add(Friend(f));
                }
              }

              for (var f in friends) {
                print(f.name);
              }
            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          print("Length: " + friends.length.toString());

                          return ListTile(
                            title: new FlatButton(
                              textColor: ThriveColors.DARK_GRAY,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      30.0)),
                              onPressed: () {
                                setState(() {
                                  friendToggle[index] = !friendToggle[index];
                                });
                              },
                              child: friend.getName(context),
                              color: friendToggle[index]
                                  ? ThriveColors.LIGHT_GREEN
                                  : ThriveColors.LIGHTEST_GREEN,
                            ),
                          );
                        },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThriveColors.LIGHT_ORANGE,
          onPressed: () {
            friendString = "";
            friendList.clear();
            for (var i = 0; i < friendToggle.length; i++) {
              if (friendToggle[i]) {
                if (!friendList.contains(friends[i].name)) {
                  friendList.add(friends[i].name);
                }

                if (friendString == "") {
                  friendString += friends[i].name;
                } else {
                  friendString += ", " + friends[i].name;
                }
              }
            }

            FriendReturn fReturn =
                new FriendReturn(friendList, friendString, friendToggle);
            Navigator.pop(context, fReturn);
          },
          child: Icon(Icons.check_circle),
        ),
      ),
    );
  }
}

class Friend {
  final String name;

  Friend(this.name);

  Widget getName(BuildContext context) {
    return Text(
      name,
      style: ThriveFonts.BODY_DARK_GRAY,
    );
  }
}
