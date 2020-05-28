import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'FriendReturn.dart';

class Collaborators extends StatefulWidget {
  final FriendReturn collabs;
  Collaborators(this.collabs);

  @override
  _CreateCollabState createState() => _CreateCollabState(collabs.returnList, collabs.returnString, collabs.returnBool);
}

class _CreateCollabState extends State<Collaborators> {
  final List<Friend> friends = [Friend("Steve"), Friend("Bob"), Friend("Dude")];
  List<String> friendList = [];
  String friendString;
  List<bool> friendToggle;

  _CreateCollabState(this.friendList, this.friendString, this.friendToggle);

  Future<bool> _onWillPop() {
    FriendReturn fReturn = new FriendReturn(friendList, friendString, friendToggle);
    Navigator.pop(context, fReturn);
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Collaborators"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50
          ),
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];

              return ListTile(
                  title: new FlatButton(
                    onPressed: () {
                      setState(() {
                        friendToggle[index] = !friendToggle[index];
                      });

                    },
                    child: friend.getName(context),
                    color: friendToggle[index] ? Colors.blue : Colors.grey,
                  )
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            friendString = "";
            friendList.clear();
            for (var i = 0; i < friendToggle.length; i++) {
              if(friendToggle[i]) {
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

            FriendReturn fReturn = new FriendReturn(friendList, friendString, friendToggle);
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
    );
  }
}