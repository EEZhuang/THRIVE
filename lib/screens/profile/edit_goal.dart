import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditGoal extends StatefulWidget {
  final Goal goal;
  final String id;
  final Function updateTile;

  EditGoal({this.goal, this.id, this.updateTile});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";

  String goal_name = '';

  String goalUnits = '';

  String goalDate = '';

  String goalRepeat = '';

  String goalProgress = '';

  String _goalDeadline = '';

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    goal_name = widget.goal.goal;
    goalUnits = widget.goal.goalUnits;
    goalDate = widget.goal.goalDate;
    goalRepeat = widget.goal.goalRepeat;
    goalProgress = widget.goal.goalProgress;
    _goalDeadline = goalDate;
    var dateText = TextEditingController(text: goalDate);

    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              String _selectedRepeat = goalRepeat;
              String _goalDeadline = goalDate;
              return StatefulBuilder(builder: (context, setState) {
                return new AlertDialog(
                    title: Center(child: new Text('Edit Goal')),
                    content: new Container(
                        width: 400,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  TextFormField(
                                    initialValue: goal_name,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please set a name for your goal";
                                      }
                                      goal_name = value;
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                        hintText: "Goal Name"),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    initialValue: goalUnits,
                                    validator: (value) {
                                      goalUnits = value;
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                        hintText: "How Many Units(Optional)"),
                                  ),
                                  SizedBox(height: 20.0),
                                  InkWell(
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
                                            //_goalDeadline = goalDate;
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
                                                _goalDeadline = value;
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
                                        print(_selectedRepeat);
                                        goalRepeat = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  RaisedButton(
                                      child: Text("Submit changes"),
                                      onPressed: () {
                                        if (_formkey.currentState.validate()) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                new AlertDialog(
                                              title: new Text('Create Goal'),
                                              content: new Text(
                                                  'Do you want to edit this goal?'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: new Text('No'),
                                                ),
                                                new FlatButton(
                                                  // TODO: Process data and make http request
                                                  onPressed: () async {
                                                    //hashing
                                                    FirebaseUser result =
                                                        await _auth
                                                            .getCurrentUser();

                                                    // If there is a current user logged in, make HTTP request
                                                    if (result != null) {
                                                      print(result.uid);
                                                      print(goal_name);
                                                      print(goalUnits);
                                                      _db.postGoal(
                                                          goal_name,
                                                          widget.id,
                                                          goalUnits,
                                                          goalDate,
                                                          goalRepeat,
                                                          goalProgress);
                                                      widget.updateTile();
                                                    }
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                  child: new Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                  SizedBox(height: 100.0),
                                  RaisedButton(
                                    child: Text('Delete goal'),
                                    onPressed: () {
                                      if (_formkey.currentState.validate()) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => new AlertDialog(
                                            title: new Text('Delete Goal'),
                                            content: new Text(
                                                'Are you sure you want to delete this goal?'),
                                            actions: <Widget>[
                                              new FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: new Text('No'),
                                              ),
                                              new FlatButton(
                                                // TODO: Process data and make http request
                                                onPressed: () async {
                                                  //hashing
                                                  FirebaseUser result =
                                                      await _auth
                                                          .getCurrentUser();

                                                  // If there is a current user logged in, make HTTP request
                                                  if (result != null) {
                                                    print(result.uid);
                                                    print(goal_name);
                                                    print(goalUnits);
                                                    bool finished = await _db.deleteGoal(
                                                        result.uid, widget.id);

                                                    if (finished){
                                                      print('do we ever get here');
                                                      widget.updateTile();
                                                    }
                                                  }

                                                  Navigator.of(context)
                                                      .pop(true);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                },
                                                child: new Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    color: Colors.red,
                                  )
                                ],
                              )),
                        )));
              });
            });
      },
    );
  }
}
