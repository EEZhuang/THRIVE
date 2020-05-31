import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_goal_list.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

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
  final _formKey = GlobalKey<FormState>();

  //String
  String goal = '';

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
          Container(
            color: ThriveColors.DARK_GREEN,
            height: ((height / 4) + 30), // here,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 30.0, top: 50), // here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 110, //here
                        width: 120, //here
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThriveColors.LIGHT_GREEN,
                          /**
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/profileimg.png"))),
                                **/
                        ),
                        child: Container(
                          child: Icon(FontAwesomeIcons.canadianMapleLeaf,
                              size: 70),
                        ),
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
                            "Vas Sengupta",
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "10.2K",
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
                                  Text("543", style: ThriveFonts.HEADING2
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
          ),
          Padding(
            padding: EdgeInsets.only(top: ((height / 4))),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ThriveColors.TRANSPARENT_BLACK,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  )),
              child: Container(
                // padding: const EdgeInsets.all(10.0),
                padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                child: GoalList(currUser: widget.currUser),
              ),
            ),
          ),
        ])

        // Button to signout and return to signin page
        /**
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          //widget.toggleHome();
          //print(_auth.getCurrentUser());
        },
      ),
          **/
        );
  }
}
