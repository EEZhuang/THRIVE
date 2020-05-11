import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:flutter/material.dart';
//import 'package:thrive/shared/constants.dart';
import 'package:thrive/shared/loading.dart';

// Register page
class Register extends StatefulWidget{
  final Function toggleView;
  final Function toggleHome;

  //Constructor receives toggleView&toggleHome functions which set state of
  //authenticate/wrapper respectively
  Register({this.toggleView, this.toggleHome});

  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register>{
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Holds state elements
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context){


    // Returns screen according to loading status
    return loading ? Loading(): Scaffold (
      backgroundColor: Colors.green[100],
      appBar: AppBar (
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text('Sign up to THRIVE'),
        actions: <Widget>[FlatButton.icon(
            onPressed: (){
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Sign In'))
        ],



      ),

      body: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50
          ),
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
                        child: Text('Register'),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if (result == null){
                              setState(() {
                                loading = false;
                                error = 'please supply a valid email';
                              });
                            } else {
                              widget.toggleHome();
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