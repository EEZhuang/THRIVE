import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thrive/services/database.dart';

class GoalTile extends StatefulWidget {
  final Goal goal;
  final String users;
  final String date;
  final List<CircleAvatar> avatars;
  final String username;
  final String goalID;
  final bool likeStatus;
  final int count;
  GoalTile({this.goal, this.users, this.date, this.avatars, this.username, this.goalID, this.likeStatus, this.count});

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  bool liked = false;
  int likes = 0;
  DatabaseService _db = DatabaseService();

  @protected
  @mustCallSuper
  void initState() {
    liked = widget.likeStatus;
    likes = widget.count;
  }

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
                    alignment: (widget.users.contains(" ")) ? Alignment.centerLeft : Alignment.center,
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
                          Text(widget.users, style: ThriveFonts.USERS_LIGHT_ORANGE,),
                          Text(" "),
                          (widget.users.contains(' ')) ? Text("are ", style: ThriveFonts.GOALTILE_WHITE,) : Text("is ", style: ThriveFonts.GOALTILE_WHITE,),
                          Text("striving to...", style: ThriveFonts.GOALTILE_WHITE,)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.goal.goal, style: ThriveFonts.GOALNAME_LIGHTEST_GREEN,)
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text("by ", style: ThriveFonts.GOALTILE_DATE_DARK_GREEN,),
                    Text(widget.goal.goalDate, style: ThriveFonts.GOALTILE_DATE_DARK_GREEN,),
                  ],
                ),
                trailing: Column(
                  children: <Widget>[
                    Text(
                      widget.date, style: ThriveFonts.GOALTILE_DATE_LIGHTEST_GREEN,
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
                percent: (double.parse(widget.goal.goalProgress) /
                    double.parse(widget.goal.goalUnits)),
                backgroundColor: ThriveColors.LIGHTEST_GREEN,
                progressColor: ThriveColors.DARK_ORANGE,
              ),
              SizedBox(
                height: 15,
              ),

              Row(
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                          icon: liked ? Icon(Icons.favorite, color: ThriveColors.WHITE) :  Icon(Icons.favorite_border, color: ThriveColors.WHITE),
                          onPressed: () async {
                            bool set = await _db.toggleLike(widget.username, widget.goalID);
                            setState(()  {
                              
                              //bool set = await _db.toggleLike(widget.username, widget.goalID);
                              if (liked){
                                likes--;
                              } else {
                                likes++;
                              }
                              liked = !liked;



                            });
                          }
                      )
                  ),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: likes.toString(),
                        style: ThriveFonts.BODY_WHITE
                      ),
                      TextSpan(
                        text: " likes"
                      )
                    ]

                    )
                  )

                ],
              ),

            ],
          ),
        ));
  }
}
