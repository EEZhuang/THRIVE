import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/profile/edit_goal.dart';

class GoalTile extends StatefulWidget{

  final Goal goal;
  GoalTile({this.goal});

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  //var dateText = TextEditingController(text: goalDate);
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";

  String goal_name = '';

  String goalUnits = '';

  String goalDate = '';

  String goalRepeat = '';

  String _goalDeadline = '';

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    goal_name = widget.goal.goal;
    goalUnits = widget.goal.goalUnits;
    goalDate = widget.goal.goalDate;
    goalRepeat = widget.goal.goalRepeat;
    _goalDeadline = goalDate;
    var dateText = TextEditingController(text: goalDate);

    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green[100],

          ),
          title: Text(widget.goal.goal),
          subtitle: Text(widget.goal.goalDate),
          trailing: EditGoal(goal: widget.goal)
        ),
      )
    );
  }
}