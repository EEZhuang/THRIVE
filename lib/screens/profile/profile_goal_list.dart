import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/shared/loading.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:intl/intl.dart';

import 'profile_goal_tile.dart';

class GoalList extends StatefulWidget {
  final FirebaseUser currUser;

  GoalList({this.currUser});

  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  bool updateVal = false;

  void updateTile() {
    setState(() {
      //_db.getAllUserGoals(widget.currUser.uid);
      updateVal = !updateVal;
    });
  }

  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();
  var goals = [];
  var ids = [];
  var goalMap = {};

  @override
  Widget build(BuildContext context) {
    var goals = [];
    var ids = [];
    var goalMap = {};

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ThriveColors.TRANSPARENT_BLACK,
        body: FutureBuilder<dynamic>(
            future: _db.getAllUserGoals(widget.currUser.uid),
            builder: (context, AsyncSnapshot snapshot) {
              goals = [];
              ids = [];
              goalMap = {};
              if (snapshot.hasData) {
                goalMap = snapshot.data;

                //find and update repeating goals that have expired
                goalMap.forEach((k, v) {
                  String stringDate = v.goalDate;
                  String repeatStatus = v.goalRepeat;
                  DateTime realDate = DateTime.parse(stringDate);
                  DateTime now = new DateTime.now();
                  DateTime todayDate = new DateTime(now.year, now.month, now.day);
                  if (realDate.isBefore(todayDate) && repeatStatus != "Don't Repeat"){

                    if (repeatStatus == "Repeat Every Day"){

                      while (realDate.isBefore(todayDate)){
                        realDate = new DateTime(realDate.year, realDate.month, realDate.day+1);
                      }

                    } else if (repeatStatus == "Repeat Every Week"){

                      while (realDate.isBefore(todayDate)){
                        realDate = new DateTime(realDate.year, realDate.month, realDate.day+7);
                      }

                    } else if (repeatStatus == "Repeat Every Month"){

                      while (realDate.isBefore(todayDate)){
                        realDate = new DateTime(realDate.year, realDate.month+1, realDate.day);
                      }

                    } else if (repeatStatus == "Repeat Every Year"){

                      while (realDate.isBefore(todayDate)){
                        realDate = new DateTime(realDate.year+1, realDate.month, realDate.day);
                      }

                    }

                    stringDate = DateFormat('yyyy-MM-dd').format(realDate);
                    //update goal in database
                    _db.postGoal(v.goal, k, v.goalUnits, stringDate, v.goalRepeat, "0");
                    //update local goal object
                    v.goalDate = stringDate;
                    v.goalProgress = "0";
                  }

                });


                goalMap.forEach((k, v) => goals.add(v));
                goalMap.forEach((k, v) => ids.add(k));

                return ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    //print(goals.length);
                    //print(goals[index]);
                    return GoalTile(
                      goal: goals[index],
                      id: ids[index],
                      updateTile: updateTile,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                //print("Here");
                return Loading();
              }
            }));
  }
}

/**
    dynamic goal = await _db.getUserGoal(widget.currUser.uid);

    var goal1 = new Goal();
    goal1.name = "Goal 1";
    goal1.goal = "Complete by: 5/18/2020";
    goal1.days = "1";

    var goal2 = new Goal();
    goal2.name = "Goal 2";
    goal2.goal = "Complete by: 5/23/2020";
    goal2.days = "2";

    final goals = [goal1, goal2];
    //print(goals);

    //print(goals.length);
    goals.forEach((goal) {
      print(goal.name);
      print(goal.goal);
      print(goal.days);
    });

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index){
        return GoalTile(goal: goals[index]);
      },
    );
  }
}
        */
