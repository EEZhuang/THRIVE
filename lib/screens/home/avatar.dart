import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'avatarList.dart';

class Avatar extends StatefulWidget {
  @override
  _CreateAvatarState createState() => _CreateAvatarState();

}
class _CreateAvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Avatar"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AvatarList()),
              );
            },
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 150,
                child: Card(
                  child: CircleAvatar(
                      backgroundColor: Colors.brown,
                    )
                ),
              ),

            ),
          ),
        ),
    );
  }
}