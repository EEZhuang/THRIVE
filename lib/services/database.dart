import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';

class DatabaseService {
  //HTTP Request to Add Friends
  void linkFriends(
      String requestingUID, String requestedUID, String accepted) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/link_friends',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'requestingUID': requestingUID,
        'requestedUID': requestedUID,
        'accepted': accepted
      }),
    );
  }

  // Makes HTTP request passing uid and goal in body
  void linkUserGoal(String username, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/link_user_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'username': username, 'goalID': goalID}),
    );
  }

  Future<bool> deleteFriend(String myuid, String frienduid) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/delete_connection',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'myuid': myuid, 'frienduid': frienduid}),
    );
    print(myuid);
    print(frienduid);
    print("before returning true");
    return true;
  }

  Future<bool> deleteGoal(String username, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/delete_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'username': username, 'goalID': goalID}),
    );
    print("before returning true");
    return true;
  }

  Future<bool> removeFriend(String username, String friend) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/remove_friend',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
      jsonEncode(<String, String>{'username': username, 'friend': friend}),
    );
    //print("before returning true");
    return true;
  }

  Future<bool> postGoal(String goal, String goalID, String goalUnits,
      String goalDates, String goalRepeat, String goalProgress) async {
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    http.Response response = await http.post(
      'http://10.0.2.2:3000/post_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'goal': goal,
        'goalID': goalID,
        'goalUnits': goalUnits,
        'goalDates': goalDates,
        'goalRepeat': goalRepeat,
        'goalProgress': goalProgress,
        'timestamp': timestamp
      }),
    );
    return true;
  }

  Future<bool> setUserInfo(String uid, String username, String firstName,
      String lastName, String birthDate) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/set_user_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
      }),
    );
    return true;
  }

  Future<bool> setUserAvatar(String username, int colorIndex, int iconIndex) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/set_user_avatar',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'colorIndex': colorIndex.toString(),
        'iconIndex': iconIndex.toString(),
      }),
    );
    return true;
  }

  Future<Tuple2<int, int>> getUserAvatar(String username) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_user_avatar',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'username': username
      },
    );

    Map<String, dynamic> json = await jsonDecode(response.body);
    Tuple2<int, int> avatarTuple =
        new Tuple2(int.parse(json['colorIndex']), int.parse(json['iconIndex']));
    return avatarTuple;
  }

  void setPublicUid(String username) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/set_public_uid',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'username': username}),
    );
  }

  void addFriend(String myusername, String otherusername) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/set_friend',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'myusername': myusername,
        'otherusername': otherusername
      }),
    );
  }

  Future<List<String>> getAllUsernames(String uid) async {
    //get user doc ids
    print("yes");
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_all_usernames',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid
      },
    );

    Map<String, dynamic> json = await jsonDecode(response.body);
    //print(json);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    List<String> usernames = json['users'].cast<String>();
    print(usernames);
    return usernames;
  }

  Future<Map<String, Goal>> getAllUserGoals(String username) async {
    //get user doc ids
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_all_goal_ids',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'username': username,
      },
    );

    Map<String, Goal> goalList = Map<String, Goal>();
    Map<String, dynamic> json = await jsonDecode(response.body);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    List<String> goal_ids = json['goal_ids'].cast<String>();
    print(goal_ids);
    for (var id in goal_ids) {
      Goal temp = await getGoal(id);
      print(temp.goalUnits);
      goalList[id] = temp;
    }
    return goalList;
  }

  Future<String> getUsername(String uid) async {
    //get user doc ids
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_username',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid,
      },
    );

    Map<String, dynamic> json = await jsonDecode(response.body);
    print(json);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    String username = json['user'];
    print(username);

    return username;
  }

  Future<List<String>> getRequests(String uid) async {
    //get user doc ids
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid
      },
    );

    Map<String, dynamic> json = await jsonDecode(response.body);
    //print(json);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    List<String> username = json['friend'].cast<String>();
    //print(username);

    return username;
  }

  // helper method
  Future<Goal> getGoal(String goalID) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'goalID': goalID,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      Goal temp = new Goal(
          goal: json['goal_name'],
          goalDate: json['goal_dates'],
          goalUnits: json['goal_units'],
          goalRepeat: json['goal_repeat'],
          goalProgress: json['goal_progress']);
      print("database");
      print(temp.goal);
      return temp;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load goal');
    }
  }

  Future<List<String>> getAllFriends(String username) async {
    //get user doc ids
    print("yes");
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_all_friends',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'username': username
      },
    );

    Map<String, dynamic> json = await jsonDecode(response.body);
    //print(json);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    List<String> friends = json['friend'].cast<String>();
    print(friends);
    return friends;
  }

  Future<int> getTimestamp(String goalID) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'goalID': goalID,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      //print("HERE"+int.parse(json['timestamp']).toString());
      return int.parse(json['timestamp']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load goal');
    }
  }

  int comparison(
      Tuple3<int, Goal, String> first, Tuple3<int, Goal, String> second) {
    if (first.item1 > second.item1) {
      return -1;
    }
    return 1;
  }

  Future<Map<String, String>> getCollabMap(String username) async {
    List<String> friends = await getAllFriends(username);
    Map<String, String> collabMap = {};

    Map<String, Goal> currUserGoals = await getAllUserGoals(username);
    currUserGoals.forEach((k, v) {
      collabMap[k] = "";
    });

    for (int i = 0; i < friends.length; i++) {
      Map<String, Goal> temp = await getAllUserGoals(friends[i]);

      temp.forEach((k, v) {
        if (collabMap.containsKey(k)) {
          if (collabMap[k] == "") {
            collabMap[k] = friends[i];
          } else {
            collabMap[k] += (", " + friends[i]);
          }
        }
      });
    }
    print(collabMap);
    return collabMap;
  }

  Future<List<Tuple4<Goal, String, String, String>>> wallMap(String username) async {
    List<Tuple3<int, Goal, String>> tempReturn =
        new List<Tuple3<int, Goal, String>>();

    List<String> friends = await getAllFriends(username);
    List<Tuple4<Goal, String, String,String>> returnList =
        new List<Tuple4<Goal, String, String, String>>();
    Map<String, String> userMap = {};

    for (int f = 0; f < friends.length; f++) {
      Map<String, Goal> temp = await getAllUserGoals(friends[f]);

      List<Goal> goals = temp.values.toList(); //list of goals
      List<String> ids = temp.keys.toList(); //list of ids
      for (int i = 0; i < goals.length; i++) {
        if (userMap.containsKey(ids[i])) {
          userMap[ids[i]] += (", " + friends[f]);
        } else {
          userMap[ids[i]] = friends[f];
          int timestamp = await getTimestamp(ids[i]);
          //print("HERE" + timestamp.toString());
          tempReturn.add(new Tuple3(timestamp, goals[i], ids[i]));
        }
      }
    }

    tempReturn.sort(comparison);

    for (int p = 0; p < tempReturn.length; p++) {
      DateTime date =
          new DateTime.fromMillisecondsSinceEpoch(tempReturn[p].item1);
      //print(date);
      var dateString = DateFormat("MMMM dd, yyyy").format(date);
      print(dateString);
      returnList.add(new Tuple4(
          tempReturn[p].item2, userMap[tempReturn[p].item3], dateString, tempReturn[p].item3));
      print("PLS WORK" + tempReturn[p].item2.goal);
    }

    return returnList;
  }

  //get size of likes collection
  Future<Map<String, int>> getLikeCount (String goalID) async{
    return new Map<String, int>();
  }

  //get whether user exists in likes collection
  Future<bool> likeExists (String username, String goalID) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/like_exists',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'username': username,
        'goalID': goalID,
      },
    );
    Map<String, dynamic> json = jsonDecode(response.body);
    //print("HERE"+int.parse(json['timestamp']).toString());
    int status = int.parse(json['status']);
    if(status == 1){
      return true;
    }
    return false;

  }

  //post toggle: if user has liked, then delete user doc. if user hasn't liked, then add user doc
  Future<bool> toggleLike(String username, String goalID) async {
    //check if user exists then delete
    bool exists = await likeExists(username,goalID);
    if (exists){
      http.Response response = await http.post(
        'http://10.0.2.2:3000/delete_like',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
        jsonEncode(<String, String>{'username': username, 'goalID': goalID}),
      );
      print("before returning true");
    } else {
      http.Response response = await http.post(
        'http://10.0.2.2:3000/add_like',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
        jsonEncode(<String, String>{'username': username, 'goalID': goalID}),
      );
    }
    return true;
  }

}
