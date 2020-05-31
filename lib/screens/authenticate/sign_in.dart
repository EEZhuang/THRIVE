import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/shared/constants.dart';
import 'package:thrive/shared/loading.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;

class SignIn extends StatefulWidget {

  final Function toggleView;
  final Function toggleHome;
  final Function toggleState;
  SignIn({this.toggleView, this.toggleHome, this.toggleState});


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>{

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold (
      //child: Text('Sign into THRIVE'),
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
          /*
        child: RaisedButton(
          child: Text('Sign in anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null){
              print('error signing in anon');

            } else {
              print('signed in');
              print(result);
            }
          }
        )*/
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
                            widget.toggleView();
                          },
                              child: Text('SIGN UP',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 20,
                                  fontFamily: 'Proxima',
                                ),
                              )),
                          FlatButton(onPressed: (){
                            //widget.toggleView();
                          },
                              child: Text('SIGN IN',
                                style: TextStyle(
                                  color: ThriveColors.WHITE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
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
                                  decoration:textInputDecoration.copyWith(hintText:  'Email'),
                                  validator: (val) => val.isEmpty ? 'Enter email' : null,
                                  onChanged: (val){
                                    setState(() {
                                      email = val;
                                    });
                                  },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration:textInputDecoration.copyWith(hintText: 'Password'),
                                  validator: (val) => val.length < 6 ? 'Enter password (6+ characters long)' : null,
                                  onChanged: (val){
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                  obscureText: true ,
                              ),
                              SizedBox(height: 20.0),
                              RaisedButton(
                                  color: ThriveColors.WHITE,
                                  splashColor: ThriveColors.DARK_ORANGE,
                                  child: Text('Sign in'),
                                  onPressed: () async {
                                    if(_formKey.currentState.validate()){
                                      setState(() => loading = true);
                                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                      if(result == null) {
                                        setState(() {
                                          loading = false;
                                          error = 'Could not sign in with those credentials';
                                        });
                                      } else {
                                        widget.toggleHome();
                                        //print("here");
                                        //widget.toggleState(1);
                                        //print("home toggled");
                                      }
                                    }
                                  }
                              ),
                              FlatButton(onPressed: (){
                                // open to forgot password page
                              },
                                  child: Text('Forgot Password?',
                                    style: TextStyle(
                                      color: ThriveColors.WHITE,
                                      fontSize: 15,
                                      fontFamily: 'Proxima',
                                    ),
                                  )
                              ),
                              SizedBox(height: 12.0),
                              Text( error, style: TextStyle(color: Colors.red) ),
                            ],
                          ),
                        ),
                      ),
                    ],
              ),
          ),
      ),
    );
  }
}