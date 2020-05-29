import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thrive/services/database.dart';

import 'FriendReturn.dart';
import 'collaborators.dart';
import 'dart:math';

class CreateGoal extends StatefulWidget {
  final Function togglePage;

  CreateGoal({this.togglePage});
  @override
  _CreateGoalState createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  final _formKey = GlobalKey<FormState>();
  String _goalDeadline = "";
  var dateText = TextEditingController();
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";
  FriendReturn collabs = FriendReturn("", List.filled(3, false));
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  //String
  String goal = '';
  String goalID = '';
  String goalUnits = '';
  String goalDate = '';
  String goalRepeat = "Don't Repeat";
  String goalProgress = "0";

  //List<String> collabList;
  var collabText = TextEditingController();

  Future<bool> _onWillPop() {
    return (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Discard Goal'),
            content: new Text('Do you want to delete this goal?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Create a Goal",
              style: TextStyle(fontFamily: 'COMIC_SANS'),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: new InputDecoration(hintText: "Goal Name"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a name for your goal";
                        }
                        goal = value; //assigns goal name for posting
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: new InputDecoration(
                          hintText: "How Many Units(Optional)"),
                      validator: (value) {
                        if (value.isEmpty) {
                          goalUnits = '0'; //goal has no units
                          return null;
                        }
                        goalUnits = value; //assigns goal units for posting
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2018),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)))
                              .then((date) {
                            setState(() {
                              _goalDeadline =
                                  DateFormat('yyyy-MM-dd').format(date);
                              dateText.text = _goalDeadline;
                            });
                          });
                        },
                        child: IgnorePointer(
                            child: new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Goal Deadline"),
                                controller: dateText,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please set a deadline for your goal";
                                  }
                                  goalDate = value;
                                  return null;
                                }))),
                    SizedBox(height: 20.0),
                    DropdownButton<String>(
                      hint: Text("Repeat"),
                      value: _selectedRepeat,
                      items: <String>[
                        "Don't Repeat",
                        "Repeat Every Day",
                        "Repeat Every Week",
                        "Repeat Every Month",
                        "Repeat Every Year"
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value;
                          goalRepeat = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                        onTap: () {
                          _getCollaborators(context);
                        },
                        child: IgnorePointer(
                          child: new TextFormField(
                            decoration: new InputDecoration(
                                hintText: "Collaborators(Optional)"),
                            controller: collabText,
                          ),
                        )),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Create Goal'),
                              content:
                                  new Text('Do you want to create this goal?'),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: new Text('No'),
                                ),
                                new FlatButton(
                                  // TODO: Process data and make http request
                                  onPressed: () async {
                                    //hashing
                                    final _random = new Random();
                                    int rand = _random.nextInt(85311);
                                    goalID = goal + rand.toString();

                                    // TODO: pass user as parameter from Wrapper()
                                    FirebaseUser result =
                                        await _auth.getCurrentUser();

                                    // If there is a current user logged in, make HTTP request
                                    if (result != null) {
                                      print(result.uid);
                                      _db.linkUserGoal(result.uid, goalID);
                                      bool done = await _db.postGoal(goal, goalID, goalUnits,
                                          goalDate, goalRepeat, goalProgress);
                                      widget.togglePage(1);

                                    }
                                    print(goal);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text("Create Goal"),
                    )
                  ],
                )),
          )),
    );
  }

  _getCollaborators(BuildContext context) async {
    collabs = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Collaborators(collabs)),
    );

    if (collabs.returnString != null) {
      collabText.text = collabs.returnString;
    }
  }
}
