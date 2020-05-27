import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';import 'package:thrive/services/database.dart';


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


  //String
  String query = '';

  TextEditingController searchTextEditingController = TextEditingController();
  // TODO: Future<QuerySnapshot> futureSearchResults;
  Future<List<TempUser>> futureSearchResults;
  List<TempUser> tempUsers = [
    TempUser("Mario",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/0/image/0/large"),
    TempUser("Donkey Kong",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/1/image/0/large.jpg"),
    TempUser("Link",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/2/image/0/large.jpg"),
    TempUser("Samus",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/3/image/0/large.jpg"),
    TempUser("Kirby",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/5/image/0/large.jpg"),
    TempUser("Fox",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/6/image/0/large.jpg"),
    TempUser("Pikachu",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/7/image/0/large.jpg"),
    TempUser("Ness",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/9/image/0/large.jpg"),
    TempUser("Captain Falcon",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/10/image/0/large.jpg"),
    TempUser("Marth",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/20/image/0/large.jpg"),
    TempUser("Ganondorf",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/23/image/0/large.jpg"),
    TempUser("Snake",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/32/image/0/large.jpg"),
    TempUser("Sonic",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/37/image/0/large.jpg"),
    TempUser("Mega Man",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/45/image/0/large.jpg"),
    TempUser("Little Mac",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/48/image/0/large.jpg"),
    TempUser("Palutena",
        "http://images.nintendolife.com/list/items/palutena/image/0/large.jpg"),
    TempUser("Pacman",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/53/image/0/large.jpg"),
    TempUser("Shulk",
        "http://images.nintendolife.com/list/items/57_shulk/image/0/large.jpg"),
    TempUser("Ryu",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/57/image/0/large.jpg"),
    TempUser("Cloud",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/58/image/0/large.jpg"),
    TempUser("Bayonetta",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/60/image/0/large.jpg"),
    TempUser("Inkling",
        "http://images.nintendolife.com/news/2018/06/gallery_super_smash_bros_ultimate_character_artwork/list-item/61/image/0/large.jpg"),
    TempUser("Richter",
        "http://images.nintendolife.com/97cdea4d0eaf5/66e-richter.large.jpg"),
    TempUser("Isabelle",
        "http://images.nintendolife.com/cf8b935d8bf7a/68-isabelle.large.jpg"),
    TempUser("Piranha Plant",
        "http://images.nintendolife.com/3c6e0c96f8418/70-piranha-plant-dlc.large.jpg"),
    TempUser("Joker",
        "http://images.nintendolife.com/8edddaab8ef43/71-joker-dlc.large.jpg"),
    TempUser("Hero",
        "http://images.nintendolife.com/dc14919720b48/72-hero-dlc.large.jpg"),
    TempUser("Banjo and Kazooie",
        "http://images.nintendolife.com/e16d42f0d0a73/73-banjo-and-kazooie-dlc.large.jpg"),
    TempUser("Terry",
        "http://images.nintendolife.com/b7132535fd103/74-terry-bogard-dlc.large.jpg"),
    TempUser("Byleth",
        "https://cdn.vox-cdn.com/thumbor/dJWWjK73KZdqamf8RZ2RbXiRbdQ=/1400x1400/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/19605610/EOaIPk4U4AANzxs.jpg"),
    TempUser("Sans",
        "https://www.siliconera.com/wp-content/uploads/2020/04/super-smash-bros-sans-undertale.jpg")
  ];

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  // condition to search for uid for each user
  controlSearching(String str) async {
    print("hi");
    FirebaseUser result = await _auth.getCurrentUser();
    List<String> usernames = await _db.getAllUsernames(result.uid);
    print("hello");

    for( int i = 0; i < usernames.length; i++) {
      tempUsers[i] = TempUser(usernames[i], "https://www.siliconera.com/wp-content/uploads/2020/04/super-smash-bros-sans-undertale.jpg");
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

