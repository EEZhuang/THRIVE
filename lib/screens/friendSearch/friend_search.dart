import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/screens/wrapper.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:thrive/services/database.dart';
import 'package:thrive/screens/friendSearch/friend_requests.dart';
import 'package:thrive/formats/fonts.dart' as ThriveFonts;
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:tuple/tuple.dart';
import 'package:thrive/formats/avatar.dart';

class Search extends StatefulWidget {
  //final Function toggleHome;
  //final Function toggleState;
  final Function togglePage;
  Search({this.togglePage});

  @override
  _SearchState createState() => _SearchState();
}

// Screen for searching friends
class _SearchState extends State<Search> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  final PageStorageBucket bucket = PageStorageBucket();

  //String
  String query = '';

  TextEditingController searchTextEditingController = TextEditingController();
  // TODO: Future<QuerySnapshot> futureSearchResults;
  Future<List<TempUser>> futureSearchResults;
  List<String> friendsList;

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  // condition to search for uid for each user
  controlSearching(String str) async {
    FirebaseUser result = await _auth.getCurrentUser();
    String username = await _db.getUsername(result.uid);
    List<String> usernames = await _db.getAllUsernames(result.uid);
    friendsList = await _db.getAllFriends(username);
    List<TempUser> tempUsers = new List();

    String requestingUID = await _db.getUsername(result.uid);

    usernames.remove(requestingUID);

    for (int i = 0; i < usernames.length; i++) {
      tempUsers.add(new TempUser(usernames[i], 0, 0));
    }

    List<TempUser> queryTempUsers = [];
    for (int i = 0; i < tempUsers.length; i++) {
      TempUser tempUser = tempUsers[i];
      String tempName = tempUser.name.toLowerCase();
      String tempStr = str.toLowerCase();
      if (str != "" && tempName.contains(tempStr)) {
        Tuple2<int, int> result = await _db.getUserAvatar(usernames[i]);
        tempUser.colorIndex = result.item1;
        tempUser.iconIndex = result.item2;
        queryTempUsers.add(tempUser);
      }
    }

    final Future<List<TempUser>> allUsers = Future<List<TempUser>>.delayed(
        Duration(seconds: 0), () => queryTempUsers);
    setState(() {
      futureSearchResults = allUsers;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
        backgroundColor: ThriveColors.DARK_GREEN,
        title: TextFormField(
          style: TextStyle(fontSize: 18.0),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: TextStyle(color: ThriveColors.LIGHT_GREEN),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThriveColors.LIGHT_ORANGE),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThriveColors.DARK_ORANGE),
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.person_pin,
              color: ThriveColors.LIGHT_ORANGE,
              size: 30.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: ThriveColors.LIGHT_ORANGE,
              ),
              onPressed: emptyTheTextFormField,
            ),
          ),
          onFieldSubmitted: controlSearching,
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(
              Icons.group_add,
              color: ThriveColors.LIGHT_ORANGE,
              size: 30,
            ),
            onPressed: () {
              print("page");
              //body: PageStorage(
              //  child: Request(),
              //  bucket: bucket,
              //);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Request()),
              );
            },
          )
        ]);
  }

  Scaffold displayNoSearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(

      body: Container(
        color: ThriveColors.TRANSPARENT_BLACK,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Icon(
                Icons.group,
                color: ThriveColors.LIGHT_ORANGE,
                size: 200.0,
              ),
              Text(
                "Search Users",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ThriveColors.LIGHT_ORANGE,
                    fontWeight: FontWeight.w500,
                    fontSize: 50.0),
              ),
            ],
          ),
        ),
      )
    );
  }

  // TODO: depends on database
  displayUsersFoundScreen() {
    return FutureBuilder(
        future: futureSearchResults,
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
            //print('test');
            //return Text('hi');
          }

          List<UserResult> searchUsersResult = [];
          for (int i = 0; i < snapshot.data.length; i++) {
            TempUser eachTempUser = snapshot.data[i];
            UserResult userResult = UserResult(eachTempUser, friendsList, widget.togglePage);
            searchUsersResult.add(userResult);
          }

          if(searchUsersResult.isEmpty) {
            return Container(
              color: ThriveColors.TRANSPARENT_BLACK,
              // TODO-BG change asset for friend search
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
                        "That username doesn't exist",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ThriveColors.LIGHT_ORANGE,
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0),
                      ),
                    )
                  ],
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
      body: futureSearchResults == null
          ? displayNoSearchResultsScreen()
          : displayUsersFoundScreen(),
      // Button to signout and return to signin page
    );
  }
}

class UserResult extends StatelessWidget {
  final TempUser eachUser; // TODO: replace friend with user
  final List<String> friendsList;
  final Function togglePage;
  UserResult(this.eachUser, this.friendsList, this.togglePage);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: ThriveColors.TRANSPARENT_BLACK,
        //color: ThriveColors.TRANSPARENT_BLACK,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AVATAR_COLORS[eachUser.colorIndex],
                  child: AVATAR_ICONS[eachUser.iconIndex],
                  //backgroundImage: NetworkImage(eachUser.imageUrl),
                ),
                title: Text(
                  eachUser.name,
                  /*
                  style: TextStyle(
                    color: ThriveColors.WHITE,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                   */
                  style: ThriveFonts.SUBHEADING_WHITE,
                ),

                trailing: (friendsList == null)? null : (friendsList.contains(eachUser.name) ? IconButton(
                  icon: Icon(Icons.clear),
                  color: ThriveColors.DARK_ORANGE,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          title: new Text('Delete Friend'),
                          content: new Text(
                              'Do you want to delete this user from your friends list?'),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: new Text('No'),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                final AuthService _auth = AuthService();
                                final DatabaseService _db =
                                DatabaseService();
                                // TODO: pass user as parameter from Wrapper()
                                FirebaseUser result =
                                await _auth.getCurrentUser();
                                String requestingUID =
                                await _db.getUsername(result.uid);

                                //TODO: call delete friends
                                bool set = await _db.removeFriend(requestingUID, eachUser.name);
                                set = await _db.removeFriend(eachUser.name, requestingUID);
                                Navigator.of(context).pop(false);
                                this.togglePage(5);
                                await new Future.delayed(const Duration(milliseconds : 250));
                                this.togglePage(3);

                              },
                              child: new Text('Yes'),
                            ),
                          ],
                        ));
                  }, // TODO: profile page can go here
                ) : IconButton(
                  icon: Icon(Icons.person_add),
                  color: ThriveColors.LIGHT_GREEN,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                              title: new Text('Add Friend'),
                              content: new Text(
                                  'Do you want to send a friend request to this user?'),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: new Text('No'),
                                ),
                                new FlatButton(
                                  onPressed: () async {
                                    final AuthService _auth = AuthService();
                                    final DatabaseService _db =
                                        DatabaseService();
                                    // TODO: pass user as parameter from Wrapper()
                                    FirebaseUser result =
                                        await _auth.getCurrentUser();
                                    String requestingUID =
                                        await _db.getUsername(result.uid);


                                          _db.linkFriends(requestingUID,
                                              eachUser.name, "false");


                                    Navigator.of(context).pop(false);
                                    this.togglePage(5);
                                    await new Future.delayed(const Duration(milliseconds : 250));
                                    this.togglePage(3);
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            ));
                  }, // TODO: profile page can go here
                )),

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
