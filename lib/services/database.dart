import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  void linkUserGoal(String uid, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/link_user_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'uid': uid, 'goalID': goalID}),
    );
  }

  Future<bool> deleteFriend(String myuid, String frienduid) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/delete_connection',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'myuid': myuid, 'frienduid': frienduid}),
    );
    print(myuid);
    print(frienduid);
    print("before returning true");
    return true;
  }

  Future<bool> deleteGoal(String uid, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/delete_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'uid': uid, 'goalID': goalID}),
    );
    print("before returning true");
    return true;
  }

  Future<bool> postGoal(String goal, String goalID, String goalUnits, String goalDates,
      String goalRepeat, String goalProgress) async {
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
        'goalProgress': goalProgress
      }),
    );
    return true;
  }

  void setUserInfo(String uid, String username, String firstName,
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
        'birthDate': birthDate
      }),
    );
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
      body: jsonEncode(<String, String>{'myusername': myusername, 'otherusername': otherusername }),
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

  Future<Map<String, Goal>> getAllUserGoals(String uid) async {
    //get user doc ids
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_all_goal_ids',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid,
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
}
