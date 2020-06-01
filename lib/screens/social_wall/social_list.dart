import 'package:flutter/cupertino.dart';
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
import 'package:thrive/formats/avatar.dart';

class SocialList extends StatefulWidget {
  final FirebaseUser currUser;

  SocialList({this.currUser});

  @override
  _SocialListState createState() => _SocialListState();
}

class _SocialListState extends State<SocialList> {
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

  var goals = [];
  var ids = [];
  var goalMap = [];
  var isExpandedList = [];
  var dates = [];
  List<List<CircleAvatar>> avatars = [];

  Future<List<Tuple3<Goal, String, String>>> localGoalMap() async {
    String username = await _db.getUsername(widget.currUser.uid);
    List<Tuple3<Goal, String, String>> wall = await _db.wallMap(username);

    //for (var f in wall) {
    for (int i = 0; i < wall.length; i++) {
      int num = 0;
      String collabStr = wall[i].item2;
      List<CircleAvatar> avForTile = [];

      // Add avatars to avatars list
      while (collabStr.length != 0 && num < 3) {
        int commaIdx = collabStr.indexOf(",");
        String user = '';
        if (commaIdx != -1) {
          user = collabStr.substring(0, commaIdx);

          collabStr = collabStr.substring(commaIdx + 2);
        } else {
          user = collabStr;
          collabStr = '';
        }

        Tuple2<int, int> result = await _db.getUserAvatar(user);

        avForTile.add(CircleAvatar(
          backgroundColor: AVATAR_COLORS[result.item1],
          child: AVATAR_ICONS[result.item2],
        ));

        //num++;
        num = num + 1;
      }

      avatars.add(avForTile);
      //avatars.insert(i, avForTile);
    }

    return wall;
  }

  Future<Tuple2<int, int>> getAvatar() async {
    String username = await _db.getUsername(widget.currUser.uid);
    return await _db.getUserAvatar(username);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<dynamic>(
            future: this.localGoalMap(),
            builder: (context, snapshot) {
              goals = [];
              ids = [];
              goalMap = [];
              dates = [];

              if (snapshot.hasData) {
                goalMap = snapshot.data;
                for (var f in goalMap) {
                  goals.add(f.item1);
                  ids.add(f.item2);
                  dates.add(f.item3);
                }
              } else {
                return Loading();
              }
              return goals.isEmpty ?
              Container(
                // TODO-BG change asset for social wall
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new ExactAssetImage("images/thrive.png"),
                              fit: BoxFit.fitWidth,
                            )
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                      "Seems like no one has a goal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ThriveColors.LIGHT_ORANGE,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0),
                      ),
                    )
                  ],
                )

              ) :
              ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                          fit: FlexFit.loose,
                          child: new GoalTile(
                              goal: goals[index],
                              users: ids[index],
                              date: dates[index],
                              avatars: avatars[index],)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: null,
                      )
                    ],
                  );
                },
              );
            }));
  }
}
