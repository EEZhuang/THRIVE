import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:percent_indicator/percent_indicator.dart';

class GoalTile extends StatelessWidget {
  final Goal goal;
  final String users;
  final String date;
  final List<CircleAvatar> avatars;

  GoalTile({this.goal, this.users, this.date, this.avatars});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3.0),
        //borderRadius: BorderRadius.circular(30.0),
        child: Card(
          //color: ThriveColors.TRANSPARENT_BLACK,
          color: Colors.transparent,
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                leading: Container(
                  width: 65,
                  child: Stack(
                    alignment: (users.contains(" ")) ? Alignment.centerLeft : Alignment.center,
                    children: <Widget>[
                      Positioned (
                        left: 14.0,
                        //bottom: 30,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: ThriveColors.DARK_GRAY,
                        ),
                      ),
                      Positioned (
                        left: 7.0,
                        //bottom: -10,
                        //top: 15,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: ThriveColors.LIGHT_GREEN,
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: ThriveColors.LIGHT_ORANGE,
                      ),
                    ],

                  ),
                ),
                title: Column (
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        runSpacing: 0,
                        //textDirection: TextDirection.rtl,
                        spacing: 0.0,
                        children: <Widget>[
                          Text(users, style: ThriveFonts.USERS_LIGHT_ORANGE,),
                          Text(" "),
                          (users.contains(' ')) ? Text("are ", style: ThriveFonts.GOALTILE_WHITE,) : Text("is ", style: ThriveFonts.GOALTILE_WHITE,),
                          Text("striving to...", style: ThriveFonts.GOALTILE_WHITE,)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(goal.goal, style: ThriveFonts.GOALNAME_LIGHTEST_GREEN,)
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text("by ", style: ThriveFonts.GOALTILE_DATE_DARK_GREEN,),
                    Text(goal.goalDate, style: ThriveFonts.GOALTILE_DATE_DARK_GREEN,),
                  ],
                ),
                trailing: Column(
                  children: <Widget>[
                    Text(
                      date, style: ThriveFonts.GOALTILE_DATE_LIGHTEST_GREEN,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // Padding to move date to upper right
                    //CircleAvatar(radius: 25, backgroundColor: Colors.transparent,),
                  ],
                ),
              ),
              //Text("hi just testing to see how long this is. is it long longer longer",),
              LinearPercentIndicator(
                //width: 370.0,
                width: 350,
                alignment: MainAxisAlignment.center,
                lineHeight: 5.0,
                percent: (double.parse(goal.goalProgress) /
                    double.parse(goal.goalUnits)),
                backgroundColor: ThriveColors.LIGHTEST_GREEN,
                progressColor: ThriveColors.DARK_ORANGE,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
