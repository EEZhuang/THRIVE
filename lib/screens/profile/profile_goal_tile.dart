import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class GoalTile extends StatelessWidget{

  final Goal goal;
  GoalTile({this.goal});

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
          title: Text(goal.goal, style: ThriveFonts.BODY_DARK_GRAY,),
          subtitle: Text(goal.goalDate),
        ),
      )
    );
  }
}