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
  _CreateCollabState createState() => _CreateCollabState(collabs.returnString, collabs.returnBool);

}
class _CreateCollabState extends State<Collaborators> {
  final List<Friend> friends = [Friend("Steve"), Friend("Bob"), Friend("Dude")];
  String friendList;
  List<bool> friendToggle;

  _CreateCollabState(this.friendList, this.friendToggle);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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

                    friendList = "";
                    for (var i = 0; i < friendToggle.length; i++) {
                      if(friendToggle[i]) {
                        if (friendList == "") {
                          friendList += friends[i].name;
                        } else {
                          friendList += ", " + friends[i].name;
                        }
                      }

                    }
                  },
                  child: friend.getName(context),
                  //borderSide: BorderSide(color: Colors.blue),
                  color: friendToggle[index] ? Colors.blue : Colors.grey,
                )
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FriendReturn fReturn = new FriendReturn(friendList, friendToggle);
            Navigator.pop(context, fReturn);
          },
          child: Icon(Icons.check_circle),
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