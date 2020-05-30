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
  var isExpandedList = [];
  //var counter = 0;
  List<double> progressList = [];
  List<TextEditingController> progressController = List<TextEditingController>();

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


                goalMap.forEach((k, v) {
                  goals.add(v);
                  isExpandedList.add(false);
                  //print("2232");
                  progressList.add(0);
                  progressController.add(TextEditingController());

                });

                //counter++;
                goalMap.forEach((k, v) => ids.add(k));

/*
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
                );*/
                //print("Test");
                //print(counter);
                print("TESASDSD" + goals.length.toString());
                //if(counter >= 0) {
                  return SingleChildScrollView(
                    child: Container(
                      color: ThriveColors.DARK_GRAY,
                      child: Theme(
                        data: Theme.of(context).copyWith(cardColor: ThriveColors.LIGHT_GREEN),
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
                            if(progressController[index].text == "") {
                              progressController[index].text = "0";
                            }


                            //if (progressList[index] == -2) {
                            //  progressList[index] =
                            //      double.parse(myGoal.goalProgress);
                            //}

                            return ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder: (BuildContext context,
                                  bool isExpanded) {
                                return GoalTile(
                                  goal: goals[index],
                                  id: ids[index],
                                  updateTile: updateTile,
                                );
                              },
                              body: Row(
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () {
                                      setState(() {
                                        if ((int.parse(myGoal.goalProgress) + progressList[index]) > 0) {
                                          progressList[index]--;
                                          progressController[index].text = progressList[index].toInt().toString();
                                        }
                                      });
                                    },
                                    child: new Icon(Icons.remove,
                                        color: ThriveColors.DARK_ORANGE),
                                    backgroundColor: ThriveColors.LIGHT_GREEN,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(labelText: "Change to goal"),
                                      controller: progressController[index],
                                      onChanged: (text) {
//                                        if(int.parse(text) > 10) {
//                                          if((int.parse(myGoal.goalProgress) + int.parse(text)) > int.parse(myGoal.goalUnits)) {
//                                            progressController[index].text = (int.parse(myGoal.goalUnits) - int.parse(myGoal.goalProgress)).toString();
//                                            progressList[index] = double.parse(myGoal.goalUnits) - double.parse(myGoal.goalProgress);
//                                          } else {
//                                            progressController[index].text =
//                                            "10";
//                                            progressList[index] = 10;
//                                          }
//                                          text = "10";
//                                        } else
                                        if((int.parse(myGoal.goalProgress) + int.parse(text)) >= int.parse(myGoal.goalUnits)) {
                                          progressController[index].text = (int.parse(myGoal.goalUnits) - int.parse(myGoal.goalProgress)).toString();
                                          progressList[index] = double.parse(myGoal.goalUnits) - double.parse(myGoal.goalProgress);
                                        } else {
                                          //progressList[index].text = text;
                                          progressList[index] = double.parse(text);
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
                                        if((int.parse(myGoal.goalProgress) + int.parse(text)) <= 0) {
                                          //print("TRUE");
                                          progressController[index].text = "-" + myGoal.goalProgress;
                                          progressList[index] = -1 * double.parse(myGoal.goalProgress);
                                        } else {
                                          progressList[index] = double.parse(text);
                                        }
                                      },
                                      //initialValue: "0",

                                    )
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () {
                                      setState(() {
                                        if ((int.parse(myGoal.goalProgress) + progressList[index]) < int.parse(myGoal.goalUnits)) {
                                          progressList[index]++;
                                          progressController[index].text = progressList[index].toInt().toString();
                                        }
                                      });
                                    },
                                    child: new Icon(Icons.add,
                                        color: ThriveColors.DARK_ORANGE),
                                    backgroundColor: ThriveColors.LIGHT_GREEN,
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      FirebaseUser result = await _auth
                                          .getCurrentUser();

                                      int tmpProg =
                                      int.parse(myGoal.goalProgress);
                                      tmpProg += progressList[index].toInt();



                                      if (tmpProg >=
                                          int.parse(myGoal.goalUnits)) {
                                        tmpProg =
                                            int.parse(myGoal.goalUnits);
                                        progressList[index] = 0;
                                        progressController[index].text = "0";
                                      } else if (tmpProg <= 0) {
                                        tmpProg = 0;
                                        progressList[index] = 0;
                                        progressController[index].text = "0";
                                      }


                                      myGoal.goalProgress = tmpProg.toString();
                                      if (result != null) {
                                        _db.postGoal(
                                            myGoal.goal,
                                            ids[index],
                                            myGoal.goalUnits,
                                            myGoal.goalDate,
                                            myGoal.goalRepeat,
                                            myGoal.goalProgress);
                                      }

                                      if((int.parse(myGoal.goalProgress) + int.parse(progressController[index].text)) > int.parse(myGoal.goalUnits)) {
                                        progressController[index].text = (int.parse(myGoal.goalUnits) - int.parse(myGoal.goalProgress)).toString();
                                        progressList[index] = double.parse(myGoal.goalUnits) - double.parse(myGoal.goalProgress);
                                      } else if((int.parse(myGoal.goalProgress) + int.parse(progressController[index].text)) < 0) {
                                        //print("TRUE");
                                        progressController[index].text = "-" + myGoal.goalProgress;
                                        progressList[index] = -1 * double.parse(myGoal.goalProgress);
                                      }

                                      setState(() {

                                      });
                                    },
                                    child: Text(
                                      "Confirm",
                                    ),
                                  ),
                                ],
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
