import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/screens/profile/edit_goal.dart';
import 'package:thrive/screens/profile/edit_goal_progress.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    DateTime realDate = DateTime.parse(widget.goal.goalDate);
    DateTime now = new DateTime.now();
    DateTime todayDate = new DateTime(now.year, now.month, now.day);
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            leading: CircularPercentIndicator(
                radius: 50,
                animation: true,
                animationDuration: 1200,
                lineWidth: 5.0,
                // indicates progress on goal
                percent: (double.parse(widget.goal.goalProgress) /
                    double.parse(widget.goal.goalUnits)),
                center: new Text(
                  widget.goal.goalUnits,
                  style: new TextStyle(
                    fontFamily: 'proxima',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: ThriveColors.DARK_GREEN,
                  ),
                ),
                backgroundColor: ThriveColors.DARK_GREEN,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: ThriveColors.DARK_ORANGE),
            title: Text(
              widget.goal.goal,
              style: new TextStyle(
                  fontFamily: 'proxima',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: realDate.isBefore(todayDate) ? ThriveColors.DARK_ORANGE : Colors.black,
              ),
            ),
            subtitle: Text(
                widget.goal.goalDate,
                style: new TextStyle(
                  color: realDate.isBefore(todayDate) ? ThriveColors.DARK_ORANGE : ThriveColors.DARK_GRAY,
                ),
            ),
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
          /*
          title: Text(goal.goal, style: ThriveFonts.BODY_DARK_GRAY,),
          subtitle: Text(goal.goalDate),
        ),
      )
    );

           */
          color: Color(0xFFF0FFED),
        ));
  }
}
