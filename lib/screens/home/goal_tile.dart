import 'package:flutter/material.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thrive/screens/profile/profile_goal_list.dart';
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
  _GoalTileState createState() => _GoalTileState(avatars);
}

class _GoalTileState extends State<GoalTile> {
  List<CircleAvatar> avatars;
  bool liked = false;
  int likes = 0;
  DatabaseService _db = DatabaseService();

  _GoalTileState(this.avatars);

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
                leading: FutureBuilder (
                  builder: (context, snapshot) {
                    List<Widget> builder = [];
                    //List<Widget> builder = [avatars[0]];
                    //for (var a in avatars) {

                    for (int i = avatars.length - 1; i >= 0; i--) {
                      Widget a = avatars[i];
                      if (i != 0) {
                        a = new Positioned(
                            left: i * 7.0,
                            child: a,
                        );
                      }
                      builder.add(a);
                    }


                    Stack avs = new Stack(
                      alignment: (builder.length > 1) ? Alignment.centerLeft : Alignment.center,
                      //alignment: Alignment.centerLeft,
                      children: builder,
                    );
                   return Container(
                     //alignment: Alignment.center,
                    width: 65,
                     child: avs,
                  );},
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
