import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

import 'FriendReturn.dart';
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
  FriendReturn collabs = FriendReturn("", List.filled(3, false));
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
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      body: SafeArea(
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
              width: MediaQuery.of(context).size.width,
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
                        //style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
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
                                child: Theme (
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
                                              decoration: InputDecoration(
                                                //suffixIcon: Icons.calendar_today,
                                                  labelText: "Goal Deadline",
                                                  labelStyle: ThriveFonts.SUBHEADING_WHITE,

                                                  focusedBorder:
                                                  UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
                                                  enabledBorder:
                                                  UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
                                                  border:
                                                  UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.WHITE))
                                              ),

                                              /*
                                            decoration: new InputDecoration(
                                                hintText: "Goal Deadline",
                                            ),

                                             */
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
                                ),
                              ),
                              //HomePage.calendarIcon(),
                            ],
                          )
                        ],
                      )
                  )
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
                              children: <Widget>[
                                Chip(
                                  label: Text("Vas"),
                                  backgroundColor: ThriveColors.WHITE,
                                  labelStyle: ThriveFonts.BODY_DARK_GRAY,
                                ),
                                Chip(
                                  label: Text("Steve"),
                                  backgroundColor: ThriveColors.DARK_ORANGE,
                                  labelStyle: ThriveFonts.BODY_WHITE,
                                ),
                                Chip(
                                  label: Text("Ed"),
                                  backgroundColor: ThriveColors.WHITE,
                                  labelStyle: ThriveFonts.BODY_DARK_GRAY,
                                ),
                                Chip(
                                  label: Text("Is"),
                                  backgroundColor: ThriveColors.WHITE,
                                  labelStyle: ThriveFonts.BODY_DARK_GRAY,
                                ),
                                Chip(
                                  label: Text("Sumi"),
                                  backgroundColor: ThriveColors.WHITE,
                                  labelStyle: ThriveFonts.BODY_DARK_GRAY,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if(_formKey.currentState.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text('Create Goal'),
                            content: new Text('Do you want to create this goal?'),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: new Text('No'),
                              ),
                              new FlatButton(
                                // TODO: Process data and make http request
                                onPressed: () => Navigator.of(context).pop(true),
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
                      width: MediaQuery.of(context).size.width - 40,
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
    );
  }

  /*
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: AppBar(
              title: Text("Create a Goal", style: ThriveFonts.HEADING),
              backgroundColor: ThriveColors.DARK_GREEN,
              centerTitle: true,
            ),
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
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Create Goal'),
                              content: new Text('Do you want to create this goal?'),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: new Text('No'),
                                ),
                                new FlatButton(
                                  // TODO: Process data and make http request
                                  onPressed: () => Navigator.of(context).pop(true),
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
                )
            ),
          )
      ),
    );
  }

   */

  _getCollaborators(BuildContext context) async {
    collabs = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Collaborators(collabs)),
    );

    if(collabs.returnString != null) {
      collabText.text = collabs.returnString;
    }
  }

}

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final Color color;
  MyTextField({this.label, this.maxLines = 1, this.minLines = 1, this.icon, this.color = ThriveColors.WHITE});

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      style: ThriveFonts.BODY_WHITE,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: ThriveFonts.SUBHEADING_WHITE,

          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.LIGHT_GREEN)),
          border:
          UnderlineInputBorder(borderSide: BorderSide(color: ThriveColors.WHITE))),

      validator: (value) {
        if (value.isEmpty) {
          return "Please fill in mandatory field";
        }
        return null;
      },
    );

  }
}