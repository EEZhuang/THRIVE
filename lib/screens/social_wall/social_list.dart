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

  //var counter = 0;
  List<double> progressList = [];
  List<TextEditingController> progressController =
      List<TextEditingController>();

  Future<List<Tuple2<Goal, String>>> localGoalMap() async {
    String username = await _db.getUsername(widget.currUser.uid);
    List<Tuple2<Goal, String>> wall = await _db.wallMap(username);
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
        backgroundColor: ThriveColors.TRANSPARENT_BLACK,
        body: FutureBuilder<dynamic>(
            future: this.localGoalMap(),
            builder: (context, AsyncSnapshot snapshot) {
              goals = [];
              ids = [];
              goalMap = [];
              if (snapshot.hasData) {
                goalMap = snapshot.data;
                for (var f in goalMap) {
                  goals.add(f.item1);
                  ids.add(f.item2);
                }
              }
              return ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xff7c94b6)
                                      /**
                                image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                             **/
                                      ),
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Text(
                                  ids[index],
                                  //style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFAF9F9)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ThriveColors.WHITE),
                                )
                              ],
                            ),
                            new IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          child: new GoalTile(goal: goals[index])
                          /**
                    Image.network(
                    "https://images.pexels.com/photos/672657/pexels-photo-672657.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                    fit: BoxFit.cover,
                    ),
                 **/
                          ),
                      SizedBox(
                        height: 10,
                      ),
                      /*
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Icon(
                          FontAwesomeIcons.heart,
                          color: ThriveColors.WHITE,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(
                          FontAwesomeIcons.comment,
                          color: ThriveColors.WHITE,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(
                            FontAwesomeIcons.paperPlane,
                            color: ThriveColors.WHITE,
                        ),
                      ],
                    ),
                    new Icon(
                        FontAwesomeIcons.bookmark,
                        color: ThriveColors.WHITE,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Liked by Patrick Star, Mr. Krabs, and 528,331 others",
                  style: TextStyle(fontWeight: FontWeight.bold, color: ThriveColors.WHITE),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    /*
                    new Container(
                      height: 30.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThriveColors.LIGHT_ORANGE,
                        /**
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                            **/
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          //border: InputBorder.none,
                          hintText: "Add a comment...",
                          //hintStyle: Color(0xFFFAF9F9),
                        ),
                        cursorColor: ThriveColors.WHITE,
                      ),
                    ),

                     */
                  ],
                ),
              ),
               */
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("1 Day Ago", style: ThriveFonts.BODY_WHITE),
                      )
                    ],
                  );
                },
              );
            }));
  }
}
