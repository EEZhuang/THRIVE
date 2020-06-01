import 'dart:math';

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
//import 'package:spritewidget/spritewidget.dart';
//import 'package:sa_v1_migration/sa_v1_migration.dart';


class GoalList extends StatefulWidget {
  final FirebaseUser currUser;

  GoalList({this.currUser});

  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> with SingleTickerProviderStateMixin {

  bool updateVal = false;
  double sOpacity;




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
  Map<String, String> collabMap = {};

  Future<Map<String, Goal>> localGoalMap() async{
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
    _db.getUsername(widget.currUser.uid).then((String name){
      username = name;
    });
    print("username:");
    print(username);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ThriveColors.TRANSPARENT_BLACK,
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
                  collabs.add(collabMap[k]);
                  isExpandedList.add(false);
                  //print("2232");
                  progressList.add(0);
                  progressController.add(TextEditingController());

                });

                //counter++;
                goalMap.forEach((k, v) => ids.add(k));
                //print("TESASDSD" + goals.length.toString());
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
                                  collabs: collabs[index],
                                  updateTile: updateTile,
                                );
                              },
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                          decoration: new InputDecoration(
                                              labelText:'Change to goal',
                                              labelStyle: ThriveFonts.BODY_DARK_GRAY,
                                          ),
                                          textAlign: TextAlign.center,
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
                                          bool goalComplete = false;



                                          if (tmpProg >=
                                              int.parse(myGoal.goalUnits)) {
                                            tmpProg =
                                                int.parse(myGoal.goalUnits);

                                            if(progressList[index].toInt() > 0) {
                                              goalComplete = true;
                                            } else {
                                              goalComplete = false;
                                            }

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


                                          if(goalComplete) {

                                            return showGeneralDialog(
                                              barrierColor: ThriveColors.TRANSPARENT_GREEN,
                                              transitionBuilder: (context, a1, a2, widget) {
                                                //print("te2233");
                                                return Stack(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      child: Circles(),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },

                                                    ),


                                                    Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                        opacity: 1,
                                                        child: AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                          ),
                                                          title: Text("Congrats on finishing your goal!"),
                                                          content: Text("Way to thrive!"),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              transitionDuration: Duration(milliseconds: 250),
                                              barrierDismissible: true,
                                                barrierLabel: "",
                                              context: context,
                                              pageBuilder: (context, animation1, animation2) {}
                                            );
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
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan> [
                                          TextSpan(
                                              text: 'Collaborators: ',
                                              style: new TextStyle(
                                                fontSize: 14,
                                                color: ThriveColors.DARK_ORANGE,
                                                fontWeight: FontWeight.bold
                                              )
                                          ),
                                          TextSpan(
                                              text: collabs[index],
                                              style: new TextStyle(
                                                  fontSize: 14,
                                                  color: ThriveColors.TRANSPARENT_BLACK,
                                              )
                                          )
                                        ]
                                      )
                                    ),
                                  ),
                                  SizedBox(height: 10)
                                ]
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

class Circles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CircleState();
  }
}

class _CircleState extends State<Circles> with SingleTickerProviderStateMixin {
  AnimationController controller;
  List<Circle> circles;
  final int cNum = 100;
  final Color color = ThriveColors.LIGHT_ORANGE;

  @override
  void initState() {
    super.initState();


    circles = List<Circle>();

    for(int i = 0; i < cNum; i++) {
      circles.add(Circle(color));
    }


    controller = new AnimationController(
        duration: const Duration(seconds: 1000), vsync: this);
    controller.addListener(() {
      newPos();
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void newPos() {
    circles.forEach((v) => v.updatePosition());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThriveColors.TRANSPARENT_GREEN,
      body: CustomPaint(
          foregroundPainter: Painter(circles: circles, controller: controller),
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)
      ),
    );
  }
}


class Painter extends CustomPainter {
  List<Circle> circles;
  AnimationController controller;

  Painter({this.circles, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    circles.forEach((v) => v.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

// Based on:
// https://github.com/anupcowkur/Bubbles/blob/master/lib/bubbles.dart
class Circle {
  Color color;
  double dir;
  double speed;
  double radius;
  double x;
  double y;
  var r = new Random();

  Circle(Color c) {
    this.color = c.withOpacity(r.nextDouble());
    this.dir = r.nextDouble() * 360;
    this.speed = 1.5;
    this.radius = r.nextDouble() * 20;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }

    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      dir = Random().nextDouble() * 360;
    }

    canvas.drawCircle(Offset(x, y), radius, paint);


  }

  updatePosition() {
    var a = 180 - (dir + 90);
    dir > 0 && dir < 180
        ? x += speed * sin(dir) / sin(speed)
        : x -= speed * sin(dir) / sin(speed);
    dir > 90 && dir < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
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
