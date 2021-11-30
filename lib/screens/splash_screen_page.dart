import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.purple, Colors.blue])
          ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body:  Center(child:Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          'WifiPay',
          style:
          TextStyle(fontFamily: 'Lobster', fontSize: 50, color: Colors.white),
        ),
          SizedBox(height: 20),
          Text("By PINTARMEDIA", style: TextStyle(color: Colors.white),)
      ],),
    )));
  }

  CheckLogin() async {
    return Timer(
      Duration(seconds: 3),
      () async {
        //String? token = await prefs.getString('token');
        String? token = await pref.read(key: "token");
        if (token != "") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyStatefulWidget()),
          );
          //MyStatefulWidget
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
    );
  }
}
