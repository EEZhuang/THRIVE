import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/profile/edit_goal.dart';

class GoalTile extends StatefulWidget{

  final Goal goal;
  final String id;
  GoalTile({this.goal, this.id});

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {

  @override
  Widget build(BuildContext context) {

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
          trailing: EditGoal(goal: widget.goal, id: widget.id)
        ),
      )
    );
  }
}