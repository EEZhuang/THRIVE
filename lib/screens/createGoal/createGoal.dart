import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/services/database.dart';

import 'FriendReturn.dart';
import 'collaborators.dart';
import 'dart:math';

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
  FriendReturn collabs = FriendReturn([], "", List.filled(3, false));
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  //String
  String goal = '';
  String goalID = '';
  String goalUnits = '';
  String goalDate = '';
  String goalRepeat = "Don't Repeat";

  List<String> collabList = [];
  var collabText = TextEditingController();
  var collabWidgets = List<Widget>();

  Future<bool> _onWillPop() {
    return (showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                decoration: BoxDecoration(
                    color: ThriveColors.DARK_GREEN,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                    )),
                height: 275,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  children: <Widget>[
                    //MyBackButton(),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Create new goal',
                          style: ThriveFonts.HEADING,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MyTextField(label: 'Goal'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      textTheme: TextTheme(
                                        subhead: ThriveFonts.BODY_WHITE,
                                      ),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2018),
                                              lastDate: DateTime.now()
                                                  .add(Duration(days: 365)))
                                              .then((date) {
                                            setState(() {
                                              _goalDeadline =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(date);
                                              dateText.text = _goalDeadline;
                                            });
                                          });
                                        },
                                        child: IgnorePointer(
                                            child: new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Goal Deadline",
                                                    labelStyle: ThriveFonts
                                                        .SUBHEADING_WHITE,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons.calendar_today,
                                                        color: ThriveColors
                                                            .DARK_GRAY,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: ThriveColors
                                                                .LIGHT_GREEN)),
                                                    enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: ThriveColors
                                                                .LIGHT_GREEN)),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                            ThriveColors.WHITE))),
                                                controller: dateText,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return "Please set a deadline for your goal";
                                                  }
                                                  return null;
                                                }))),
                                  ),
                                ),
                                //HomePage.calendarIcon(),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: MyTextField(
                                  label: 'Units',
                                  //icon: downwardIcon,
                                )),
                            SizedBox(width: 40),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: ThriveColors.DARK_GREEN,
                              ),
                              child: DropdownButton<String>(
                                itemHeight: 72,
                                style: ThriveFonts.SUBHEADING_WHITE,
                                hint: Text("Repeat"),
                                focusColor: ThriveColors.LIGHT_GREEN,
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
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Collaborators',
                                style: ThriveFonts.SUBHEADING_WHITE,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                //direction: Axis.vertical,
                                alignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                runSpacing: 0,
                                //textDirection: TextDirection.rtl,
                                spacing: 10.0,
                                children: collabWidgets,
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle),
                                iconSize: 35,
                                color: ThriveColors.DARK_ORANGE,
                                tooltip: 'Add friends as collaborators',
                                onPressed: () {
                                  //print(collabText.text);
                                  //print(collabList);

                                  collabWidgets.clear();

                                  _getCollaborators(context);

                                  setState(() {

                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Container(
                height: 80,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                            new AlertDialog(
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
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: new Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Text(
                          'Create Goal',
                          //style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                          style: ThriveFonts.HEADING2,
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        decoration: BoxDecoration(
                          color: ThriveColors.LIGHT_GREEN,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

  _getCollaborators(BuildContext context) async {
    collabs = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Collaborators(collabs)),
    );

    if (collabs.returnList.isNotEmpty) {
      collabText.text = collabs.returnString;
      collabList = collabs.returnList;
    } else {
      collabList.clear();
    }

    for (var collab in collabList) {
      collabWidgets.add(
          Chip(
            label: Text(collab),
            backgroundColor: ThriveColors
                .LIGHT_ORANGE,
            labelStyle: ThriveFonts.BODY_DARK_GRAY,
          )
      );
    }
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final Color color;
  MyTextField(
      {this.label,
        this.maxLines = 1,
        this.minLines = 1,
        this.icon,
        this.color = ThriveColors.WHITE});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: ThriveFonts.BODY_WHITE,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: icon == null ? null : icon,
          labelText: label,
          labelStyle: ThriveFonts.SUBHEADING_WHITE,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: ThriveColors.WHITE))),
      validator: (value) {
        if (value.isEmpty) {
          return "Please fill in mandatory field";
        }
        return null;
      },
    );
  }
}
