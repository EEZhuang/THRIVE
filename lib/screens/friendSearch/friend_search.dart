import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';import 'package:thrive/services/database.dart';
import 'package:thrive/screens/friendSearch/friend_requests.dart';


class Search extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  Search({this.toggleHome, this.toggleState});

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



  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  // condition to search for uid for each user
  controlSearching(String str) async {
    print("hi");
    FirebaseUser result = await _auth.getCurrentUser();

    List<String> usernames = await _db.getAllUsernames(result.uid);
    List<TempUser> tempUsers = new List();
    print("hello");
    String requestingUID = await _db.getUsername(result.uid);

    usernames.remove(requestingUID);

    for( int i = 0; i < usernames.length; i++) {
      tempUsers.add( new TempUser(usernames[i], "https://www.siliconera.com/wp-content/uploads/2020/04/super-smash-bros-sans-undertale.jpg"));
    }



    List<TempUser> queryTempUsers = [];
    for (int i = 0; i < tempUsers.length; i++) {
      TempUser tempUser = tempUsers[i];
      String tempName = tempUser.name.toLowerCase();
      String tempStr = str.toLowerCase();
      if (str != "" && tempName.contains(tempStr)) {
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
      title: TextFormField(
        style: TextStyle(fontSize: 18.0),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.person_pin,
            color: Colors.black,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: emptyTheTextFormField,
          ),
        ),
        onFieldSubmitted: controlSearching,
      ),
      actions: <Widget>[
    // action button
        IconButton(
          icon: Icon(Icons.send),
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
      ]
    );
  }

  Container displayNoSearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Colors.white,
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
              "Search Users",
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
    return Scaffold(


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
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                  new AlertDialog(
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
                          final DatabaseService _db = DatabaseService();
                          // TODO: pass user as parameter from Wrapper()
                          FirebaseUser result = await _auth.getCurrentUser();
                          String requestingUID = await _db.getUsername(result.uid);

                          _db.linkFriends(requestingUID, eachUser.name, "false");

                          Navigator.of(context).pop(false);
                        },
                        child: new Text('Yes'),
                      ),
                    ],
                  )
                );
              }, // TODO: profile page can go here
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(eachUser.imageUrl),
                ),
                title: Text(
                  eachUser.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
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

