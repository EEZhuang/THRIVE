import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/profile/edit_goal.dart';
import 'package:thrive/screens/profile/edit_goal_progress.dart';

class GoalTile extends StatefulWidget {
  final Goal goal;
  final String id;
  final Function updateTile;

  GoalTile({this.goal, this.id, this.updateTile});

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EditGoalProgress(
                    goal: widget.goal,
                    id: widget.id,
                    updateTile: widget.updateTile),
                EditGoal(
                    goal: widget.goal,
                    id: widget.id,
                    updateTile: widget.updateTile)
              ],
            ),
          ),
        ));
  }
}
