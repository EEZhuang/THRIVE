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
  //int i = 0;

  AppBar searchPageHeader() {
    //if (i == 0) {
      //getFriends();
      //print(i);
      //i++;
   // }
    return AppBar(
      title: Text("Friend Requests", style: ThriveFonts.HEADING),
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
      users.add(TempUser(requests[i],
          "https://www.siliconera.com/wp-content/uploads/2020/04/super-smash-bros-sans-undertale.jpg"));
    }
    print("what");
    print("no" + users.toString());

    final Future<List<TempUser>> allUsers =
        Future<List<TempUser>>.delayed(Duration(seconds: 0), () => users);
    setState(() {
      friends = allUsers;
    });

    return requests;
  }

  Container displayNoSearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: ThriveColors.TRANSPARENT_BLACK,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.group,
              color: Colors.grey,
              size: 200.0,
            ),
            Text(
              "Friend Requests",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 65.0),
            ),
          ],
        ),
      ),
    );
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

          return ListView(children: searchUsersResult);
        });
  }

  @override
  Widget build(BuildContext context) {
    //print("hi");
    getFriends();
    return Scaffold(
      backgroundColor: ThriveColors.TRANSPARENT_BLACK,
      appBar: searchPageHeader(),
      body: friends == null
          ? displayNoSearchResultsScreen()
          : displayUsersFoundScreen(),
      //Button to signout and return to signin page
    );
  }
}

class UserResult extends StatefulWidget {
  final TempUser eachUser; // TODO: replace friend with user
  UserResult(this.eachUser);

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.transparent,
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
                  backgroundColor: ThriveColors.LIGHTEST_GREEN,
                  //backgroundImage: NetworkImage(eachUser.imageUrl),
                ),
                title: Text(
                  widget.eachUser.name,
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
                Row (
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
                        FirebaseUser result =
                        await _auth.getCurrentUser();
                        String requestingUID =
                        await _db.getUsername(result.uid);

                        _db.addFriend(widget.eachUser.name, requestingUID);
                        _db.addFriend(requestingUID, widget.eachUser.name);
                        _db.deleteFriend(requestingUID, widget.eachUser.name);
                        setState() {

                        }

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
                        FirebaseUser result =
                        await _auth.getCurrentUser();
                        String requestingUID =
                        await _db.getUsername(result.uid);

                        _db.deleteFriend(requestingUID, widget.eachUser.name);

                        setState() {

                        }
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
  final String imageUrl;
  TempUser(this.name, this.imageUrl);

  Widget getName(BuildContext context) {
    return Text(
      name,
    );
  }
}
