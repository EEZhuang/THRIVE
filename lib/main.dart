
//import 'package:provider/provider.dart';
import 'package:thrive/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';

import 'models/user.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );

  }
}


/*
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
 */