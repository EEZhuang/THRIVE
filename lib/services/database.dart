import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService {
  // Makes HTTP request passing uid and goal in body
  void postUserGoal(String uid, String goal, String goalID) async {
    http.Response response = await http.post(
      'http://10.0.2.2:3000/goals',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'goal': goal,
        'goalID': goalID
      }),
    );
  }

  Future<String> getUserGoal(String uid, String goalID) async {
    http.Response response = await http.get(
      'http://10.0.2.2:3000/goals',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid,
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
      print("database");
      print(json['userGoal']);
      return json['userGoal'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load goal');
    }
  }
}