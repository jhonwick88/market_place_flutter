import 'package:flutter/material.dart';
import 'package:market_place_flutter/mainapp.dart';
import 'package:market_place_flutter/screens/login_page.dart';
import 'package:market_place_flutter/screens/splash_screen_page.dart';
import 'package:market_place_flutter/utils/constants.dart';

void main() {
  runApp(MyAppNew());
}

class MyAppNew extends StatelessWidget {
  // final bool isLoged = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WifiPay',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.blueGrey[900],
          accentColor: Colors.blueGrey[800],
          buttonColor: Colors.blueGrey[900],
          elevatedButtonTheme:
              ElevatedButtonThemeData(style: raisedButtonStyle)),

      //home: SplashScreenPage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreenPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => MyStatefulWidget(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("WifiPay"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Icon(Icons.cancel),
        backgroundColor: Colors.green,
      ),
    );
  }
}
