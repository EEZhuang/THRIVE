import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'profile_goal_tile.dart';

class GoalList extends StatefulWidget {
  final FirebaseUser currUser;

  GoalList({this.currUser});

  @override
  _GoalListState createState() => _GoalListState();


}

class _GoalListState extends State<GoalList> {
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();
  

  @override
  Widget build(BuildContext context) {

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
