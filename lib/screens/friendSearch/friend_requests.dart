import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive/services/database.dart';
import 'dart:convert';
import 'package:thrive/services/database.dart';
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:tuple/tuple.dart';
import 'package:thrive/formats/avatar.dart';

class Request extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Request({this.toggleHome, this.toggleState});

  @override
  _RequestState createState() => _RequestState();
}

// Screen for searching friends
class _RequestState extends State<Request> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  final PageStorageBucket bucket = PageStorageBucket();
  Future<List<TempUser>> friends;
  int i = 0;

  AppBar searchPageHeader() {
    if (i == 0) {
      getFriends();
      i++;
    }
    return AppBar(
      title: Text(
        "Friend Requests",
        style: ThriveFonts.HEADING,
      ),
      centerTitle: true,
      backgroundColor: ThriveColors.DARK_GREEN,
    );
  }

  Future<List<String>> getFriends() async {
    FirebaseUser result = await _auth.getCurrentUser();
    String requestingUID = await _db.getUsername(result.uid);
    List<String> requests = await _db.getRequests(requestingUID);
    List<TempUser> users = new List();

    for (int i = 0; i < requests.length; i++) {
      Tuple2<int, int> result = await _db.getUserAvatar(requests[i]);
      users.add(new TempUser(requests[i], result.item1, result.item2));
    }

    final Future<List<TempUser>> allUsers =
        Future<List<TempUser>>.delayed(Duration(seconds: 0), () => users);
    setState(() {
      friends = allUsers;
    });

    return requests;
  }

  // TODO: depends on database
  displayUsersFoundScreen() {
    return FutureBuilder(
        future: friends,
        builder: (context, AsyncSnapshot<List<TempUser>> snapshot) {
          if (!snapshot.hasData) {
            List<Widget> children = <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Awaiting result...')
                  ],
                ),
              )
            ];
            return children[0];
          }

          List<UserResult> searchUsersResult = [];
          for (int i = 0; i < snapshot.data.length; i++) {
            TempUser eachTempUser = snapshot.data[i];
            UserResult userResult = UserResult(eachTempUser);
            searchUsersResult.add(userResult);
          }

          if(searchUsersResult.isEmpty) {
            return Scaffold(

              body: Container(
                  color: ThriveColors.TRANSPARENT_BLACK,
                // TODO-BG change asset for friend requests
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: new ExactAssetImage("images/thrive.png"),
                                fit: BoxFit.fitWidth,
                              )
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          "No friend requests",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ThriveColors.LIGHT_ORANGE,
                              fontWeight: FontWeight.w500,
                              fontSize: 30.0),
                        ),
                      )
                    ],
                  )

              )
            );
          } else {
            return ListView(children: searchUsersResult);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      appBar: searchPageHeader(),
      body: displayUsersFoundScreen(),
      //Button to signout and return to signin page
    );
  }
}

class UserResult extends StatelessWidget {
  final TempUser eachUser; // TODO: replace friend with user
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: ThriveColors.TRANSPARENT_BLACK,
        child: Column(
          children: <Widget>[
            GestureDetector(
              /*
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                          title: new Text('Add Friend'),
                          content: new Text(
                              'Do you want to accept this Friend Request?'),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () async {
                                final AuthService _auth = AuthService();
                                final DatabaseService _db = DatabaseService();
                                // TODO: pass user as parameter from Wrapper()
                                FirebaseUser result =
                                    await _auth.getCurrentUser();
                                String requestingUID =
                                    await _db.getUsername(result.uid);

                                _db.deleteFriend(requestingUID, eachUser.name);
                                Navigator.of(context).pop(false);
                              },
                              child: new Text('Decline'),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                final AuthService _auth = AuthService();
                                final DatabaseService _db = DatabaseService();
                                // TODO: pass user as parameter from Wrapper()
                                FirebaseUser result =
                                    await _auth.getCurrentUser();
                                String requestingUID =
                                    await _db.getUsername(result.uid);

                                _db.addFriend(eachUser.name, requestingUID);
                                _db.addFriend(requestingUID, eachUser.name);
                                _db.deleteFriend(requestingUID, eachUser.name);

                                Navigator.of(context).pop(false);
                              },
                              child: new Text('Accept'),
                            ),
                          ],
                        ));
              },

               */
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AVATAR_COLORS[eachUser.colorIndex],
                  child: AVATAR_ICONS[eachUser.iconIndex],
                  //backgroundImage: NetworkImage(eachUser.imageUrl),
                ),
                title: Text(
                  eachUser.name,
                  style: ThriveFonts.SUBHEADING_WHITE,
                ),
                trailing:
                    /*
                IconButton(
                  icon: Icon(Icons.check),
                  color: ThriveColors.LIGHT_GREEN,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          title: new Text('Add Friend'),
                          content: new Text(
                              'Do you want to accept this Friend Request?'),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () async {
                                final AuthService _auth = AuthService();
                                final DatabaseService _db = DatabaseService();
                                // TODO: pass user as parameter from Wrapper()
                                FirebaseUser result =
                                await _auth.getCurrentUser();
                                String requestingUID =
                                await _db.getUsername(result.uid);

                                _db.deleteFriend(requestingUID, eachUser.name);
                                Navigator.of(context).pop(false);
                              },
                              child: new Text('Decline'),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                final AuthService _auth = AuthService();
                                final DatabaseService _db = DatabaseService();
                                // TODO: pass user as parameter from Wrapper()
                                FirebaseUser result =
                                await _auth.getCurrentUser();
                                String requestingUID =
                                await _db.getUsername(result.uid);

                                _db.addFriend(eachUser.name, requestingUID);
                                _db.addFriend(requestingUID, eachUser.name);
                                _db.deleteFriend(requestingUID, eachUser.name);

                                Navigator.of(context).pop(false);
                              },
                              child: new Text('Accept'),
                            ),
                          ],
                        ));
                  },
                  //color: ThriveColors.WHITE,
                ),
                 */
                    Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check),
                      iconSize: 30,
                      color: ThriveColors.LIGHT_GREEN,
                      //color: ThriveColors.WHITE,
                      onPressed: () async {
                        final AuthService _auth = AuthService();
                        final DatabaseService _db = DatabaseService();
                        // TODO: pass user as parameter from Wrapper()
                        FirebaseUser result = await _auth.getCurrentUser();
                        String requestingUID =
                            await _db.getUsername(result.uid);

                        _db.addFriend(eachUser.name, requestingUID);
                        _db.addFriend(requestingUID, eachUser.name);
                        _db.deleteFriend(requestingUID, eachUser.name);

                        //Navigator.of(context).pop(false);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      iconSize: 30,
                      color: ThriveColors.DARK_ORANGE,
                      //color: ThriveColors.WHITE,
                      onPressed: () async {
                        final AuthService _auth = AuthService();
                        final DatabaseService _db = DatabaseService();
                        // TODO: pass user as parameter from Wrapper()
                        FirebaseUser result = await _auth.getCurrentUser();
                        String requestingUID =
                            await _db.getUsername(result.uid);

                        _db.deleteFriend(requestingUID, eachUser.name);
                        //Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempUser {
  final String name;
  //final String imageUrl;
  int colorIndex;
  int iconIndex;
  TempUser(this.name, this.colorIndex, this.iconIndex);

  Widget getName(BuildContext context) {
    return Text(
      name,
    );
  }
}
