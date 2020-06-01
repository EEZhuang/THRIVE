import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/home/goal_tile.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/shared/loading.dart';
import 'package:tuple/tuple.dart';

class SocialList extends StatefulWidget {
  final FirebaseUser currUser;

  SocialList({this.currUser});

  @override
  _SocialListState createState() => _SocialListState();
}

class _SocialListState extends State<SocialList> {
  // bool updateVal = false;

  /*
  void updateTile() {
    setState(() {
      //_db.getAllUserGoals(widget.currUser.uid);
      updateVal = !updateVal;
    });
  }
*/

  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

  var goals = [];
  var ids = [];
  var goalMap = [];
  var isExpandedList = [];
  var dates = [];
  var goalIDs = [];
  String username = "";

  //var counter = 0;
  // List<double> progressList = [];
  // List<TextEditingController> progressController =
  //   List<TextEditingController>();

  Future<List<Tuple4<Goal, String, String, String>>> localGoalMap() async {
    username = await _db.getUsername(widget.currUser.uid);
    List<Tuple4<Goal, String, String, String>> wall = await _db.wallMap(username);
    return wall;
    //print("size:");
    //print("size:" + wall.length.toString());
    //Map<String, Goal> goalMap = await _db.getAllUserGoals(username);
    // return await _db.getAllUserGoals(username);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        //backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      backgroundColor: Colors.transparent,
        body: FutureBuilder<dynamic>(
            future: this.localGoalMap(),
            builder: (context, snapshot) {
              goals = [];
              ids = [];
              goalMap = [];
              dates = [];
              goalIDs = [];
              //print("BEFORE SNAP HAS DATA");

              if (snapshot.hasData) {
                goalMap = snapshot.data;
                for (var f in goalMap) {
                  goals.add(f.item1);
                  ids.add(f.item2);
                  dates.add(f.item3);
                  goalIDs.add(f.item4);
                  //print("AFTER SNAP HAS DATA ");
                  //print(f.toString());
                }
              } else {
                return Loading();
              }
              return ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                          fit: FlexFit.loose,
                          child: new GoalTile(goal: goals[index], users: ids[index], date: dates[index], currUser: username, goalID: goalIDs[index])
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //child: Text(dates[index], style: ThriveFonts.BODY_WHITE),
                        child: null,
                      )
                    ],
                  );
                },
              );
            }));
  }
}
