import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Collaborators extends StatefulWidget {
  @override
  _CreateCollabState createState() => _CreateCollabState();

}
class _CreateCollabState extends State<Collaborators> {
  final List<Friend> friends = [Friend("Steve"), Friend("Bob"), Friend("Dude")];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Thrive Test"),
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
                    Navigator.pop(context, friend.getName(context));
                  },
                  child: friend.getName(context),
                )
              );
            },
          )
        )
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