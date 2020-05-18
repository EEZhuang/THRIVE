import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

class AvatarList extends StatefulWidget {
  @override
  _CreateAvatarListState createState() => _CreateAvatarListState();

}
class _CreateAvatarListState extends State<AvatarList> {
  RandomColor _randomColor = RandomColor();

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
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(25, (index) {
            return Center (
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.white30),
                  child: new Container(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundColor: _randomColor.randomColor(),
                    ),
                  )
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}