import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  final Function toggleHome;
  SignIn({this.toggleView, this.toggleHome});


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
      backgroundColor: Colors.green[100],
      appBar: AppBar (
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text('Sign into THRIVE'),
        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text('Register'))
        ],



      ),

      body: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50
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

          child: Form(
              key:_formKey,
              child: Column(
                  children: <Widget> [
                    SizedBox(height: 20.0),
                    TextFormField(
                      //decoration:textInputDecoration.copyWith(hintText:  'Email'),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val){
                          setState(() {
                            email = val;
                          });
                        }
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      //decoration:textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ cahrs long' : null,
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true ,
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.white,
                        child: Text('Sign in'),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            //print("result here" + result);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Could not sign in with those credentials';
                              });
                            } else {
                              print("here");
                              widget.toggleHome();
                              print("home toggled");
                            }
                          }
                        }
                    ),
                    SizedBox(height: 12.0),
                    Text( error, style: TextStyle(color: Colors.red) ),
                  ]
              )
          )

      ),

    );
  }
}