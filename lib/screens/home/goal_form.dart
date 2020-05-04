import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/services/database.dart';
import  'package:thrive/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:thrive/shared/loading.dart';

class GoalForm extends StatefulWidget {
  @override
  _GoalFormState createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {

  final _formKey = GlobalKey<FormState>();

  //Form values
  String _currentName;
  String _currentGoal;
  String _currentDays;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {

            UserData userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Define your goals!',
                    style: TextStyle(fontSize: 18.0),
                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Update username'),
                    validator: (val) =>
                    val.isEmpty
                        ? 'Please enter a name'
                        : null,
                    onChanged: (val) => setState(() => _currentName = val),

                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.goal,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter goal'),
                    validator: (val) =>
                    val.isEmpty
                        ? 'Please enter a name'
                        : null,
                    onChanged: (val) => setState(() => _currentGoal = val),

                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.days,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter number of days'),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                    val.isEmpty
                        ? 'Please enter a name'
                        : null,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (val) =>
                        setState(() => _currentDays = val),


                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.green[500],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          await DatabaseService(uid: user.uid).updateUserData(_currentGoal ?? userData.goal, _currentName ?? userData.name, _currentDays ?? userData.days);
                        }
                        Navigator.pop(context);
                      }
                  ),

                ],
              ),

            );
          } else {
            return Loading();
          }
        }
    );
  }
}



