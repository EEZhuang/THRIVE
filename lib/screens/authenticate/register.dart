import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:flutter/material.dart';
//import 'package:thrive/shared/constants.dart';
import 'package:thrive/shared/loading.dart';
import 'package:thrive/shared/constants.dart';
import '../../formats/colors.dart';
import 'package:intl/intl.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;

class Register extends StatefulWidget {
  final Function toggleView;
  final Function toggleHome;
  final Function toggleState;
  Register({this.toggleView, this.toggleHome, this.toggleState});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  var dateText = TextEditingController();
  String _birthdate = "";
  final DatabaseService _db = DatabaseService();
  List<String> allUsers;

  String firstname = '';
  String lastname = '';
  String email = '';
  String birthdate = "";
  String username = "";
  String password = '';
  String password2 = '';
  String error = '';

  getAllUsers() async {
    allUsers = await _db.getAllUsernames("");
  }

  @override
  Widget build(BuildContext context) {
    getAllUsers();
    // Returns screen according to loading status
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF69A297), const Color(0xFF27353F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  //end: Alignment(.7, -.7),
                  //end: Alignment(-.7, -.7)
                  //end: Alignment(-1.05, -.5)
                  //end: Alignment(1.05, -.5),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'THRIVE',
                      style: TextStyle(
                        color: ThriveColors.WHITE,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        fontFamily: 'Proxima',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              //widget.toggleView();
                            },
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: ThriveColors.WHITE,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'Proxima',
                              ),
                            )),
                        FlatButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 20,
                                fontFamily: 'Proxima',
                              ),
                            )),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter your first name'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter your first name' : null,
                              onChanged: (val) {
                                setState(() {
                                  firstname = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter your last name'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter your last name' : null,
                              onChanged: (val) {
                                setState(() {
                                  lastname = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter an email'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 365)))
                                    .then((date) {
                                  setState(() {
                                    _birthdate =
                                        DateFormat('MM-dd-yyyy').format(date);
                                    dateText.text = _birthdate;
                                    birthdate = dateText.text;
                                  });
                                });
                              },
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Enter your birth date'),
                                  controller: dateText,
                                  validator: (value) => value.isEmpty
                                      ? 'Please enter your birth date'
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      //birthdate = dateText.text;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Enter a username'),
                                validator: (val) {
                                  if (allUsers.contains(val)) {
                                    return "Enter a username that has not been used";
                                  } else if (val.isEmpty) {
                                    return "Enter a username";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    username = val;
                                  });
                                }),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter a password'),
                              validator: (val) => val.length < 6
                                  ? 'Enter a password (6+ characters long)'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: true,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Confirm your password'),
                              validator: (val) => (val != password)
                                  ? 'Password does not match'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password2 = val;
                                });
                              },
                              obscureText: true,
                            ),
                            SizedBox(height: 12.0),
                            Text(error, style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: ThriveColors.WHITE,
                          splashColor: ThriveColors.DARK_ORANGE,
                          child: Text('Sign up'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please provide a valid email';
                                });
                              } else {
                                print(username +
                                    firstname +
                                    lastname +
                                    birthdate);
                                bool set = await _db.setUserInfo(result.uid,
                                    username, firstname, lastname, birthdate);
                                _db.setPublicUid(username);
                                var rng = new Random();
                                set = await _db.setUserAvatar(
                                    username, rng.nextInt(9), rng.nextInt(7));
                                if (set) {
                                  widget.toggleHome();
                                }
                              }
                            }
                          }),
                    ]),
                  ],
                ),
              ),
            ),
          );
  }
}
