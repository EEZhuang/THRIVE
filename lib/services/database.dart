import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService {
  // Makes HTTP request passing uid and goal in body
  void linkUserGoal(String uid, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/link_user_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'goalID': goalID
      }),
    );
  }

  void postGoal(String goal, String goalID, String goalUnits, String goalDates, String goalRepeat) async {
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
        'goalRepeat': goalRepeat

      }),
    );
  }

  void setUserInfo(String uid, String username, String firstName, String lastName, String birthDate) async {
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
      body: jsonEncode(<String, String>{
        'username': username

      }),
    );
  }

  Future <List<Goal>> getAllUserGoals(String uid) async {
    //get user doc ids
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_all_goal_ids',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid' : uid,
      },
    );

    List<Goal> goalList = List<Goal>();
    Map<String, dynamic> json = await jsonDecode(response.body);
    //Map<String, dynamic> json = new Map<String, dynamic>.from(jsonDecode(response.body));
    List<String> goal_ids = json['goal_ids'].cast<String>();
    print(goal_ids);
    for (var id in goal_ids){
      Goal temp = await getGoal(id);
      print(temp.goalUnits);
      goalList.add(temp);
    }
    return goalList;
  }
  // helper method
  Future <Goal> getGoal(String goalID) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/get_goal',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'goalID' : goalID,
      },
    );

    /*
    Map<String, dynamic> json = jsonDecode(response.body);
    print(json);
    print("databasee");
    print(json['userGoal']);
    return json['userGoal'];*/

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      Goal temp = new Goal(goal:json['goal_name'], goalDate: json['goal_dates'], goalUnits: json['goal_units'], goalRepeat: json['goal_repeat']);
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