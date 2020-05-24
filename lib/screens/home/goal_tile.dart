import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';

class GoalTile extends StatelessWidget{

  final Goal goal;
  GoalTile({this.goal});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 1.0),
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(30.0),
        child: Card(
          /*
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),

          ),

           */
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green[100],
                ),
                title: Text(goal.goal),
                subtitle: Text(goal.goalDate),
            ),
            color: Color(0xFFf0ffed),
          ),
        ),
      ),
    );
  }
}