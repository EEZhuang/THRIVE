import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'collaborators.dart';

class CreateGoal extends StatefulWidget {
  @override
  _CreateGoalState createState() => _CreateGoalState();

}
class _CreateGoalState extends State<CreateGoal> {
  final _formKey = GlobalKey<FormState>();
  String _goalDeadline = "";
  var dateText = TextEditingController();
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";
  String collab;
  //List<String> collabList;
  var collabText = TextEditingController();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: new InputDecoration(
                  hintText: "Goal Name"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name for your goal";
                  }
                  return null;
                },
              ),
              /*
              RaisedButton(
                child: Text(_goalDeadline),
                onPressed: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime.now().add(Duration(days: 365))
                  ).then((date) {
                    setState(() {
                      _goalDeadline = date.toString();
                    });
                  });
                },
              ),*/
              SizedBox(height: 20.0),
              TextFormField(
                decoration: new InputDecoration(
                  hintText: "How Many Units(Optional)"
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime.now().add(Duration(days: 365))
                  ).then((date) {
                    setState(() {
                      _goalDeadline = DateFormat('yyyy-MM-dd').format(date);
                      dateText.text = _goalDeadline;
                    });
                  });
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        hintText: "Goal Deadline"
                    ),
                    controller: dateText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please set a deadline for your goal";
                      }
                      return null;
                    }
                  )
                )
              ),
              SizedBox(height: 20.0),
              /*
              InkWell(
                onTap: () {

                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        hintText: "Repeat"
                    ),
                    controller: repeatText,
                  ),
                )
              ),*/
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
                            hintText: "Collaborators(Optional)"
                        ),
                        controller: collabText,
                      ),
                  )
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    // TODO: Process data and make http request
                    Navigator.pop(context);
                  }
                },
                child: Text("Create Goal"),
              )
            ],
          )
        ),
      )
    );
  }

  _getCollaborators(BuildContext context) async {
    collab = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Collaborators()),
    );

    collabText.text = collab;
    //collabList.add(collab);

  }
}