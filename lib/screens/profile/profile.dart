import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_goal_list.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:tuple/tuple.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/formats/avatar.dart';

// "User home page", screen useer sees after successful login
class Profile extends StatefulWidget {
  final FirebaseUser currUser;
  Profile({this.currUser});
  @override
  _ProfileState createState() => _ProfileState();
}

// TODO: add form key validation
class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  //String
  String username = ' ';
  String friendCount = ' ';
  String goalCount = '';
  Tuple2<int, int> avatar = new Tuple2(0, 0);

  Future<bool> getAllInfo(String uid) async {
    username = await _db.getUsername(uid);
    List<String> friends = await _db.getAllFriends(username);
    friendCount = friends.length.toString();
    Map<String, Goal> allGoals = await _db.getAllUserGoals(username);
    goalCount = allGoals.keys.length.toString();
    avatar = await _db.getUserAvatar(username);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: ThriveColors.DARK_GREEN,
        /*
        appBar: AppBar(
          title: Text("My Profile", style: ThriveFonts.HEADING),
          centerTitle: true,
          backgroundColor: ThriveColors.DARK_GREEN,
        ),
        */
        body: Stack(overflow: Overflow.visible, children: <Widget>[
          FutureBuilder<dynamic>(
            future: this.getAllInfo(widget.currUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: ThriveColors.DARK_GREEN,
                  height: ((height / 4) + 30), // here,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 30.0, top: 50), // here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 110, //here
                              width: 120, //here
                              /*
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThriveColors.LIGHT_GREEN,
                            /**
                                image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/profileimg.png"))),
                             **/
                          ),
                          */
                              //child: Container(
                              child: CircleAvatar(
                                backgroundColor: AVATAR_COLORS[avatar.item1],
                                child: AVATAR_ICONS_PROFILE[avatar.item2],
                              ),
                              //  ),
                            ),
                            SizedBox(
                              width: 10, //here
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 40)),
                                Text(
                                  // TODO INSERT USERNAME HERE
                                  username,
                                  style: ThriveFonts.HEADING,
                                  /*
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 3, // here
                                  fontWeight: FontWeight.bold),
                                   */
                                ),
                                SizedBox(
                                  height: 10, // here
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left: 20)),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          goalCount,
                                          style: ThriveFonts.HEADING2,
                                          /*
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 3, // here
                                  fontWeight: FontWeight.bold),
                               */
                                        ),
                                        Text(
                                          "Goals",
                                          style: ThriveFonts.SUBHEADING_WHITE,

                                          /*TextStyle(
                                color: Colors.white70,
                                fontSize: 1.9, // here
                              ),
                                  */
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(friendCount,
                                            style: ThriveFonts.HEADING2
                                            /*
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 3, //here
                                  fontWeight: FontWeight.bold),
                               */
                                            ),
                                        Text(
                                          "Friends",
                                          style: ThriveFonts.SUBHEADING_WHITE,
                                          /*
                              TextStyle(
                                color: Colors.white70,
                                fontSize: 1.9, //here
                              ),
                               */
                                        ),
                                      ],
                                    ),
                                    /*
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "EDIT PROFILE",
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 1.8), //here
                            ),
                          ),
                        ),
                        */
                                  ],
                                ),
                                /*
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/fb.png",
                                      height: 3, //here
                                      width: 3, //here
                                    ),
                                    SizedBox(
                                      width: 2, //here
                                    ),
                                    Text(
                                      "Protorix",
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 1.5, // here
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 7, // here
                                ),
                                /*
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/insta.png",
                                      height: 3, // here
                                      width: 3, //here
                                    ),
                                    SizedBox(
                                      width: 2, // here
                                    ),
                                    Text(
                                      "Protorix",
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 1.5, // here
                                      ),
                                    ),
                                  ],
                                )
                                */
                              ],
                            )
                            */
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3, // here
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: ((height / 4))),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ThriveColors.DARK_GRAY,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  )),
              child: Container(
                // padding: const EdgeInsets.all(10.0),
                padding: EdgeInsets.only(top: 30, right: 0, left: 0),
                child: GoalList(currUser: widget.currUser),
              ),
            ),
          ),
        ])

        // Button to signout and return to signin page
        );
  }
}
