import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditGoalProgress extends StatefulWidget {
  final Goal goal;
  final String id;
  final Function updateTile;

  EditGoalProgress({this.goal, this.id, this.updateTile});

  @override
  _EditGoalProgressState createState() => _EditGoalProgressState();
}

class _EditGoalProgressState extends State<EditGoalProgress> {
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";

  String goal_name = '';

  String goalUnits = '';

  String goalDate = '';

  String goalRepeat = '';

  String _goalDeadline = '';
  String goalProgress = ' ';

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    int _itemCount = 1;
    goal_name = widget.goal.goal;
    goalUnits = widget.goal.goalUnits;
    goalDate = widget.goal.goalDate;
    goalRepeat = widget.goal.goalRepeat;
    _goalDeadline = goalDate;
    goalProgress = widget.goal.goalProgress;

    var dateText = TextEditingController(text: goalDate);
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              String _selectedRepeat = goalRepeat;
              String _goalDeadline = goalDate;
              return StatefulBuilder(builder: (context, setState) {
                return new AlertDialog(
                    title: Center(child: new Text('Update Goal Progress')),
                    content: new Container(
                      width: 400,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new IconButton(
                                      icon: new Icon(Icons.remove),
                                      onPressed: () =>
                                          setState(() => _itemCount--),
                                    ),
                                    //  : new Container(),
                                    new Text(_itemCount.toString()),
                                    new IconButton(
                                        icon: new Icon(Icons.add),
                                        onPressed: () =>
                                            setState(() => _itemCount++))
                                  ]),
                              new RaisedButton(
                                  child: Text("Submit changes"),
                                  onPressed: () {
                                    if (_formkey.currentState.validate()) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => new AlertDialog(
                                          title: new Text('Update Progress'),
                                          content: new Text(
                                              'Do you want to update your progress?'),
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
                                                // update goalProgress
                                                int tmpProg =
                                                    int.parse(goalProgress);
                                                tmpProg += _itemCount;
                                                if (tmpProg >=
                                                    int.parse(goalUnits)) {
                                                  tmpProg =
                                                      int.parse(goalUnits);
                                                }
                                                goalProgress =
                                                    tmpProg.toString();
                                                if (result != null) {
                                                  _db.postGoal(
                                                      goal_name,
                                                      widget.id,
                                                      goalUnits,
                                                      goalDate,
                                                      goalRepeat,
                                                      goalProgress);
                                                  widget.updateTile();
                                                }

                                                Navigator.of(context).pop(true);
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
                                  })
                            ],
                          )),
                    ));
              });
            });
      },
    );
  }
}
