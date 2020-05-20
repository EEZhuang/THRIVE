import 'package:flutter/material.dart';
import 'package:thrive/screens/social_wall/social_list.dart';

class social_wall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[Flexible(child: social_list())],
    );
  }
}
