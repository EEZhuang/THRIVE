import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/shared/loading.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'profile_goal_tile.dart';
// import 'package:thrive/formats/custom_expansion_tile.dart' as custom;

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
  var isExpandedList = [];
  //var counter = 0;
  List<double> progressList = [];

  List<TextEditingController> progressController =
      List<TextEditingController>();
  Map<String, String> collabMap = {};

  Future<Map<String, Goal>> localGoalMap() async {
    String username = await _db.getUsername(widget.currUser.uid);
    collabMap = await _db.getCollabMap(username);
    //List<Tuple3<Goal, String, String>> wall = await _db.wallMap(username);
    //print("size:");
    //print("size:" + wall.length.toString());
    //Map<String, Goal> goalMap = await _db.getAllUserGoals(username);
    return await _db.getAllUserGoals(username);
  }

  @override
  Widget build(BuildContext context) {
    var goals = [];
    var ids = [];
    var goalMap = {};
    var collabs = [];
    String username = "";
    _db.getUsername(widget.currUser.uid).then((String name) {
      username = name;
    });
    print("username:");
    print(username);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ThriveColors.DARK_GRAY,
        body: FutureBuilder<dynamic>(
            future: this.localGoalMap(),
            builder: (context, AsyncSnapshot snapshot) {
              goals = [];
              ids = [];
              goalMap = {};
              collabs = [];
              if (snapshot.hasData) {
                goalMap = snapshot.data;

                //find and update repeating goals that have expired
                goalMap.forEach((k, v) {
                  String stringDate = v.goalDate;
                  String repeatStatus = v.goalRepeat;
                  DateTime realDate = DateTime.parse(stringDate);
                  DateTime now = new DateTime.now();
                  DateTime todayDate =
                      new DateTime(now.year, now.month, now.day);
                  if (realDate.isBefore(todayDate) &&
                      repeatStatus != "Don't Repeat") {
                    if (repeatStatus == "Repeat Every Day") {
                      while (realDate.isBefore(todayDate)) {
                        realDate = new DateTime(
                            realDate.year, realDate.month, realDate.day + 1);
                      }
                    } else if (repeatStatus == "Repeat Every Week") {
                      while (realDate.isBefore(todayDate)) {
                        realDate = new DateTime(
                            realDate.year, realDate.month, realDate.day + 7);
                      }
                    } else if (repeatStatus == "Repeat Every Month") {
                      while (realDate.isBefore(todayDate)) {
                        realDate = new DateTime(
                            realDate.year, realDate.month + 1, realDate.day);
                      }
                    } else if (repeatStatus == "Repeat Every Year") {
                      while (realDate.isBefore(todayDate)) {
                        realDate = new DateTime(
                            realDate.year + 1, realDate.month, realDate.day);
                      }
                    }

                    stringDate = DateFormat('yyyy-MM-dd').format(realDate);
                    //update goal in database
                    _db.postGoal(
                        v.goal, k, v.goalUnits, stringDate, v.goalRepeat, "0");
                    //update local goal object
                    v.goalDate = stringDate;
                    v.goalProgress = "0";
                  }
                });

                goalMap.forEach((k, v) {
                  goals.add(v);
                  collabs.add(collabMap[k]);
                  isExpandedList.add(false);
                  //print("2232");
                  progressList.add(0);
                  progressController.add(TextEditingController());
                });

                //counter++;
                goalMap.forEach((k, v) => ids.add(k));
                print("TESASDSD" + goals.length.toString());
                //if(counter >= 0) {
                return SingleChildScrollView(
                  child: Container(
                    color: ThriveColors.DARK_GREEN,
                    child: Theme(
                      // isMaterialAppTheme: true,
                      data: Theme.of(context).copyWith(
                          cardColor: ThriveColors.DARK_GRAY,
                          // cardColor: ThriveColors.LIGHT_ORANGE,
                          buttonColor: ThriveColors.WHITE,
                          primaryColor: ThriveColors.LIGHT_ORANGE,
                          toggleableActiveColor: ThriveColors.LIGHT_ORANGE,
                          accentColor: ThriveColors.LIGHT_ORANGE,
                          iconTheme: IconThemeData(
                              color: ThriveColors.LIGHT_ORANGE, opacity: 50)),
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            isExpandedList[index] = !isExpanded;
                          });
                        },
                        children: Iterable<int>.generate(goals.length)
                            .toList()
                            .map<ExpansionPanel>((index) {
                          //print("index: " + index.toString());
                          //print("goal: " + goals[index].goal);
                          Goal myGoal = goals[index];
                          if (progressController[index].text == "") {
                            progressController[index].text = "0";
                          }

                          return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return GoalTile(
                                goal: goals[index],
                                id: ids[index],
                                collabs: collabs[index],
                                updateTile: updateTile,
                              );
                            },
                            body: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 50,
                                        child: FloatingActionButton(
                                          mini: true,
                                          onPressed: () {
                                            setState(() {
                                              if ((int.parse(
                                                          myGoal.goalProgress) +
                                                      progressList[index]) >
                                                  0) {
                                                progressList[index]--;
                                                progressController[index].text =
                                                    progressList[index]
                                                        .toInt()
                                                        .toString();
                                              }
                                            });
                                          },
                                          child: new Icon(Icons.remove,
                                              color: ThriveColors.DARK_ORANGE),
                                          backgroundColor:
                                              ThriveColors.LIGHTEST_GREEN,
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: <Widget>[
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                              labelText: 'Change to goal',
                                              labelStyle:
                                                  ThriveFonts.SUBHEADING_WHITE,
                                              alignLabelWithHint: true,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: ThriveFonts.BODY_WHITE,
                                            controller:
                                                progressController[index],
                                            onChanged: (text) {
                                              if ((int.parse(
                                                          myGoal.goalProgress) +
                                                      int.parse(text)) >=
                                                  int.parse(myGoal.goalUnits)) {
                                                progressController[index]
                                                    .text = (int.parse(
                                                            myGoal.goalUnits) -
                                                        int.parse(myGoal
                                                            .goalProgress))
                                                    .toString();
                                                progressList[index] =
                                                    double.parse(
                                                            myGoal.goalUnits) -
                                                        double.parse(myGoal
                                                            .goalProgress);
                                              } else {
                                                //progressList[index].text = text;
                                                progressList[index] =
                                                    double.parse(text);
                                              }

//                                        if(int.parse(text) < -10) {
//
//                                          if((int.parse(myGoal.goalProgress) + int.parse(text)) < 0) {
//                                            progressController[index].text = "-" + myGoal.goalProgress;
//                                            progressList[index] = -1 * double.parse(myGoal.goalProgress);
//                                          } else {
//                                            progressController[index].text = "-10";
//                                            progressList[index] = -10;
//                                            //text = "-10";
//                                          }
//                                        } else
                                              if ((int.parse(
                                                          myGoal.goalProgress) +
                                                      int.parse(text)) <=
                                                  0) {
                                                //print("TRUE");
                                                progressController[index].text =
                                                    "-" + myGoal.goalProgress;
                                                progressList[index] = -1 *
                                                    double.parse(
                                                        myGoal.goalProgress);
                                              } else {
                                                progressList[index] =
                                                    double.parse(text);
                                              }
                                            },
                                            //initialValue: "0",
                                          ),
                                        ],
                                      )),
                                      Container(
                                        height: 30,
                                        width: 50,
                                        child: FloatingActionButton(
                                          mini: true,
                                          onPressed: () {
                                            setState(() {
                                              if ((int.parse(
                                                          myGoal.goalProgress) +
                                                      progressList[index]) <
                                                  int.parse(myGoal.goalUnits)) {
                                                progressList[index]++;
                                                progressController[index].text =
                                                    progressList[index]
                                                        .toInt()
                                                        .toString();
                                              }
                                            });
                                          },
                                          child: new Icon(
                                            Icons.add,
                                            color: ThriveColors.DARK_ORANGE,
                                          ),
                                          backgroundColor:
                                              ThriveColors.LIGHTEST_GREEN,
                                        ),
                                      ),
                                      //  SizedBox(width: 10),
                                      FlatButton(
                                        onPressed: () async {
                                          FirebaseUser result =
                                              await _auth.getCurrentUser();

                                          int tmpProg =
                                              int.parse(myGoal.goalProgress);
                                          tmpProg +=
                                              progressList[index].toInt();

                                          if (tmpProg >=
                                              int.parse(myGoal.goalUnits)) {
                                            tmpProg =
                                                int.parse(myGoal.goalUnits);
                                            progressList[index] = 0;
                                            progressController[index].text =
                                                "0";
                                          } else if (tmpProg <= 0) {
                                            tmpProg = 0;
                                            progressList[index] = 0;
                                            progressController[index].text =
                                                "0";
                                          }

                                          myGoal.goalProgress =
                                              tmpProg.toString();
                                          if (result != null) {
                                            _db.postGoal(
                                                myGoal.goal,
                                                ids[index],
                                                myGoal.goalUnits,
                                                myGoal.goalDate,
                                                myGoal.goalRepeat,
                                                myGoal.goalProgress);
                                          }

                                          if ((int.parse(myGoal.goalProgress) +
                                                  int.parse(
                                                      progressController[index]
                                                          .text)) >
                                              int.parse(myGoal.goalUnits)) {
                                            progressController[index].text =
                                                (int.parse(myGoal.goalUnits) -
                                                        int.parse(myGoal
                                                            .goalProgress))
                                                    .toString();
                                            progressList[index] =
                                                double.parse(myGoal.goalUnits) -
                                                    double.parse(
                                                        myGoal.goalProgress);
                                          } else if ((int.parse(
                                                      myGoal.goalProgress) +
                                                  int.parse(
                                                      progressController[index]
                                                          .text)) <
                                              0) {
                                            //print("TRUE");
                                            progressController[index].text =
                                                "-" + myGoal.goalProgress;
                                            progressList[index] = -1 *
                                                double.parse(
                                                    myGoal.goalProgress);
                                          }

                                          setState(() {});
                                        },
                                        child: new Icon(
                                          Icons.check,
                                          color: ThriveColors.DARK_ORANGE,
                                        ),
                                        /*Text(
                                          "Confirm",
                                        ),

                                         */
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 0, 0),
                                    child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: 'Collaborators: ',
                                          style: new TextStyle(
                                              fontSize: 14,
                                              color: ThriveColors.DARK_ORANGE,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: collabs[index],
                                          style: new TextStyle(
                                            fontSize: 14,
                                            color: ThriveColors.WHITE,
                                          )),
                                    ])),
                                  ),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                            isExpanded: isExpandedList[index],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
                //} else {
                //  return Loading();
                //}
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                //print("Here");
                return Loading();
              }
            }));
  }
}
