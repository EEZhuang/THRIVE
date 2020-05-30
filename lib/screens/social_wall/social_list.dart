import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/home/goal_tile.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class social_list extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    // Added to help with hard coding
    var goal1 = new Goal();
    goal1.goal = "Making more Krabby Patties";
    goal1.goalDate = "Streak: 1";
    goal1.goalUnits = "1";

    var goal2 = new Goal();
    goal2.goal = "Eating Healthy";
    goal2.goalDate = "Streak: 2";
    goal2.goalUnits = "2";

    final goals = [goal1, goal2];
    //print(goals);

    //print(goals.length);
    /**
    goals.forEach((goal) {
      print(goal.name);
      print(goal.goal);
      print(goal.days);
    }
         ); **/

    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
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
                        "Spongebob Squarepants",
                        //style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFAF9F9)),
                        style: TextStyle(fontWeight: FontWeight.bold, color: ThriveColors.WHITE),
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
            Flexible(fit: FlexFit.loose, child: new GoalTile(goal: goals[0])
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
  }
}
