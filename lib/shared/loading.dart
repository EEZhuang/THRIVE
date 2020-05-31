import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: ThriveColors.DARK_GREEN,
      child: Center(
        child: SpinKitDoubleBounce(
          color: ThriveColors.LIGHT_GREEN,
          size: 50,
        )
      )
    );
  }
}