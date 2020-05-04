import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:provider/provider.dart';
import  'package:thrive/services/database.dart';
import 'package:thrive/models/goal.dart';
import 'goal_form.dart';
import 'goal_list.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (conext) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: GoalForm(),
        );
      });
    }




    return StreamProvider<List<Goal>>.value(
      value: DatabaseService().goals,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Thrive'),
          backgroundColor: Colors.green[400],
          elevation: 0.0  ,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async{
                await _auth.signOut();
              },
              label: Text('logout')
            ),

            FlatButton.icon(
              icon: Icon(Icons.beenhere),
              label: Text('Goal'),
              onPressed:() => _showSettingsPanel()
            )

          ]
        ),

        body: GoalList(),

      ),
    );
  }
}