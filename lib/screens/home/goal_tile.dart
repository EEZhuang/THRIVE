import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class GoalTile extends StatelessWidget {
  final Goal goal;
  final String users;
  final String date;

  GoalTile({this.goal, this.users, this.date});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        //borderRadius: BorderRadius.circular(30.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: ThriveColors.DARK_GRAY,
            ),
            title: Text(goal.goal),
            subtitle: Text(goal.goalDate),
            trailing: Column(
              children: <Widget>[
                Text(
                  date,
                  style: ThriveFonts.SUBHEADING_LIGHTEST_GREEN,
                ),
                // Padding to move date to upper right
                CircleAvatar(radius: 15, backgroundColor: Colors.transparent,),
              ],
            ),
          ),
        ));
  }
}
