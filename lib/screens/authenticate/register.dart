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

class _RegisterState extends State<Register>{
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  var dateText = TextEditingController();
  String _birthdate = "";
  final DatabaseService _db = DatabaseService();

  String firstname = '';
  String lastname = '';
  String email = '';
  String birthdate = "";
  String username = "";
  String password = '';
  String password2 = '';
  String error = '';

  @override
  Widget build(BuildContext context){
    // Returns screen according to loading status
    return loading ? Loading(): Scaffold (
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
          key:_formKey,
          child: Column(
            children: <Widget> [
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
                children: <Widget> [
                  FlatButton(onPressed: (){
                    //widget.toggleView();
                  },
                      child: Text('SIGN UP',
                        style: TextStyle(
                          color: ThriveColors.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'Proxima',
                        ),
                      )),
                  FlatButton(onPressed: (){
                    widget.toggleView();
                  },
                      child: Text('SIGN IN',
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
                    children: <Widget> [
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText:  'Enter your first name'),
                        validator: (val) => val.isEmpty ? 'Enter your first name' : null,
                        onChanged: (val){
                          setState(() {
                            firstname = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText:  'Enter your last name'),
                        validator: (val) => val.isEmpty ? 'Enter your last name' : null,
                        onChanged: (val){
                          setState(() {
                            lastname = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText:  'Enter an email'),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val){
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
                              lastDate: DateTime.now().add(Duration(days: 365))
                          ).then((date) {
                            setState(() {
                              _birthdate = DateFormat('MM-dd-yyyy').format(date);
                              dateText.text = _birthdate;
                            });
                          });
                        },
                        child: IgnorePointer(
                          child: new TextFormField(
                            decoration:textInputDecoration.copyWith(hintText:  'Enter your birth date'),
                            controller: dateText,
                            validator: (value) => value.isEmpty ? 'Please enter your birth date' : null,
                            onChanged: (value){
                              setState(() {
                                birthdate = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText:  'Enter a username'),
                        validator: (val) => val.isEmpty ? 'Enter a username' : null,
                        onChanged: (val){
                          setState(() {
                            username = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText: 'Enter a password'),
                        validator: (val) => val.length < 6 ? 'Enter a password (6+ characters long)' : null,
                        onChanged: (val){
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true ,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:textInputDecoration.copyWith(hintText:  'Confirm your password'),
                        validator: (val) => (val != password) ? 'Password does not match' : null,
                        onChanged: (val){
                          setState(() {
                            password2 = val;
                          });
                        },
                        obscureText: true ,
                      ),
                      SizedBox(height: 12.0),
                      Text( error, style: TextStyle(color: Colors.red) ),
                    ],
                  ),
                ),
              ),
              Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: ThriveColors.WHITE,
                        splashColor: ThriveColors.DARK_ORANGE,
                        child: Text('Sign up'),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please provide a valid email';
                              });
                            } else {
                              print(username + firstname + lastname + birthdate);
                              _db.setUserInfo(result.uid, username, firstname, lastname, birthdate);
                              _db.setPublicUid(username);
                              widget.toggleHome();
                            }
                          }
                        }
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}






















/*
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:flutter/material.dart';
//import 'package:thrive/shared/constants.dart';
import 'package:thrive/shared/loading.dart';
import '../../formats/colors.dart';
import 'package:intl/intl.dart';
import 'package:thrive/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

// Register page
class Register extends StatefulWidget {
  final Function toggleView;
  final Function toggleHome;
  final Function toggleState;

  //Constructor receives toggleView&toggleHome functions which set state of
  //authenticate/wrapper respectively
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

  //Holds state elements
  String email = '';
  String password = '';
  String password2 = '';
  String username = "";
  String firstname = '';
  String lastname = '';
  String birthdate = "";
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
            backgroundColor: Colors.green[100],
            appBar: AppBar(
              backgroundColor: Colors.green[400],
              elevation: 0.0,
              title: Text('Sign up to THRIVE'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Sign In'))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: DARK_GREEN, width: 5.0),
                              ),
                              hintText: 'Enter an email'),
                          //decoration:textInputDecoration.copyWith(hintText:  'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          }),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: DARK_GREEN, width: 5.0),
                            ),
                            hintText: 'Enter a password'),
                        //decoration:textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: DARK_GREEN, width: 5.0),
                            ),
                            hintText: 'Confirm your password'),
                        //decoration:textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => (val != password)
                            ? 'password does not match'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password2 = val;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: DARK_GREEN, width: 5.0),
                              ),
                              hintText: 'Enter a username'),
                          //decoration:textInputDecoration.copyWith(hintText:  'Email'),
                          //validator: (val) => val.isEmpty ? 'Enter a username' : null,
                          validator: (val) {
                            if (allUsers.contains(val)) {
                              return "Enter a username that has not been used";
                            } else if (val.isEmpty) {
                              return "Enter a username";
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              username = val;
                            });
                          }),
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: DARK_GREEN, width: 5.0),
                              ),
                              hintText: 'Enter your first name'),
                          //decoration:textInputDecoration.copyWith(hintText:  'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter your first name' : null,
                          onChanged: (val) {
                            setState(() {
                              firstname = val;
                            });
                          }),
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: DARK_GREEN, width: 5.0),
                              ),
                              hintText: 'Enter your last name'),
                          //decoration:textInputDecoration.copyWith(hintText:  'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter your last name' : null,
                          onChanged: (val) {
                            setState(() {
                              lastname = val;
                            });
                          }),
                      InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 365)))
                                .then((date) {
                              setState(() {
                                _birthdate =
                                    DateFormat('MM-dd-yyyy').format(date);
                                dateText.text = _birthdate;
                              });
                            });
                          },
                          child: IgnorePointer(
                              child: new TextFormField(
                                  decoration: new InputDecoration(
                                      hintText: "Enter your birth date"),
                                  controller: dateText,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your birth date";
                                    }
                                    birthdate = value;
                                    return null;
                                  }))),
                      RaisedButton(
                          color: Colors.white,
                          child: Text('Register'),
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                (username != "") &&
                                (firstname != "") &&
                                (lastname != "") &&
                                (password != "") &&
                                (password2 != "") &&
                                (birthdate != "")) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'please supply a valid email';
                                });
                              } else {
                                //http the username, first name, last name, and birth date of user into UID
                                print(username +
                                    firstname +
                                    lastname +
                                    birthdate);
                                var rng = new Random();
                                _db.setUserInfo(
                                  result.uid,
                                  username,
                                  firstname,
                                  lastname,
                                  birthdate,
                                );
                                _db.setPublicUid(username);
                                _db.setUserAvatar(
                                    username, rng.nextInt(9), rng.nextInt(6));
                                widget.toggleHome();
                              }
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(error, style: TextStyle(color: Colors.red))
                    ]))),
          );
  }
}
*/
