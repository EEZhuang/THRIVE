import 'package:provider/provider.dart';
import 'package:thrive/models/user.dart';
import 'package:thrive/screens/home/home.dart';
import 'package:thrive/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    // TODO: implement build
    if (user == null) {
      return Authenticate();
    }else {
      return Home();
    }
  }
}