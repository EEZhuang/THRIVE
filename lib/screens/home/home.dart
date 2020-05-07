import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/models/goal.dart';
import 'goal_form.dart';
import 'goal_list.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Test> fetchTest() async {
  final response = await http.get('http://10.0.2.2:3000/notes');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Test.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load the data');
  }
}

class Test {
  final String testStr;

  Test({this.testStr});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testStr: json['notes'],
    );
  }
}

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: GoalForm(),
            );
          });
    }

    return StreamProvider<List<Goal>>.value(
      value: DatabaseService().goals,
      child: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
              title: Text('Thrive'),
              backgroundColor: Colors.green[400],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.person),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    label: Text('logout')),
                FlatButton.icon(
                    icon: Icon(Icons.beenhere),
                    label: Text('Goal'),
                    onPressed: () => _showSettingsPanel())
              ]),
          body: Center(
            //GoalList(),
            child: FutureBuilder<Test>(
              future: fetchTest(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.testStr);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          )),
    );
  }
}
