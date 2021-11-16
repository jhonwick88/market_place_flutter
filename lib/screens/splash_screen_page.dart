import 'dart:async';

import 'package:flutter/material.dart';
import 'package:market_place_flutter/mainapp.dart';
import 'package:market_place_flutter/screens/login_page.dart';
import 'package:market_place_flutter/utils/shared_preferences_actions.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  var pref = SharedPreferencesActions();
  @override
  void initState() {
    super.initState();
    CheckLogin();
    //Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }

  CheckLogin() async {
    return Timer(
      Duration(seconds: 3),
      () async {
        //String? token = await prefs.getString('token');
        String? token = await pref.read(key: "token");
        if (token != "") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
    );
  }
}
