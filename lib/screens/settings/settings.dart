import 'package:flutter/material.dart';
import 'package:thrive/services/auth.dart';
import 'package:thrive/screens/Password/password.dart';
import 'package:thrive/screens/Password/changepass.dart';
import 'package:thrive/screens/DeleteAcc/delete.dart';
import 'package:thrive/screens/home/home.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class Settings extends StatefulWidget {
  final Function toggleHome;
  final Function togglePage;
  Settings({this.toggleHome, this.togglePage});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontFamily: 'Proxima', fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        //brightness: Brightness.light,
        //iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xFF69A297),
      ),
      backgroundColor: Color(0xF0080F0F),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: ThriveColors.LIGHTEST_GREEN,
              child: Column(
                children: <Widget>[
                  //_buildDivider(),
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: ThriveColors.DARK_GREEN),
                    title: Text("Change Password", style: TextStyle(fontFamily: 'Proxima')),
                    trailing: Icon(Icons.keyboard_arrow_right, color: ThriveColors.DARK_GREEN),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Password(togglePage: widget.togglePage)));
                    },
                  ),
                  _buildContainer(),
                  ListTile(
                    leading: Icon(Icons.delete, color: ThriveColors.DARK_GREEN),
                    title: Text("Delete Account", style: TextStyle(fontFamily: 'Proxima')),
                    trailing: Icon(Icons.keyboard_arrow_right, color: ThriveColors.DARK_GREEN),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Delete(toggleHome: widget.toggleHome)));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.only(left: 150.0, right: 150.0),
              color: ThriveColors.DARK_ORANGE,
              child: ListTile(
                onTap: () async {
                  await _auth.signOut();
                  widget.toggleHome();
                },
                title: Text("Logout", textAlign: TextAlign.center, style: TextStyle(color: ThriveColors.BLACK, fontFamily: 'Proxima', fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}