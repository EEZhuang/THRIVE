import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thrive/models/goal.dart';
import 'goal_tile.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context) ?? [];
    //print(goals);

    //print(goals.length);
    goals.forEach((goal) {
      print(goal.name);
      print(goal.goal);
      print(goal.days);
    });

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalTile(goal: goals[index]);
      },
    );
  }
}
