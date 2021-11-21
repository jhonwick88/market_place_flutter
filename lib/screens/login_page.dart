import 'package:flutter/material.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/models/user_login.dart';
import 'package:market_place_flutter/utils/ProgressHUD.dart';
import 'package:market_place_flutter/utils/shared_preferences_actions.dart';

import '../mainapp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  String response = '';
  bool isApiCallProcess = false;
  var pref = SharedPreferencesActions();
  late String email, password;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: _uiLogin(context),
        inAsyncCall: isApiCallProcess,
        color: Theme.of(context).primaryColor);
  }

  Widget _uiLogin(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor:
            Theme.of(context).primaryColor, //Theme.of(context).accentColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white, //Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'WifiPay',
                            style:
                                TextStyle(fontFamily: 'Lobster', fontSize: 33),
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            validator: (value) => !value!.contains('@')
                                ? 'Email tidak benar'
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            initialValue: '',
                            decoration: new InputDecoration(
                              hintText: 'Email',
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            validator: (value) => value!.length < 4
                                ? "Password minimal 4 karakter"
                                : null,
                            obscureText: hidePassword,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: new InputDecoration(
                                hintText: 'Password',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).accentColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                )),
                          ),
                          SizedBox(height: 30),
                          TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Theme.of(context).buttonColor,
                                side: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1),
                                elevation: 20,
                                minimumSize: Size(300, 50),
                                shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () async {
                                // print("emial " + email!);
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  final client = ApiClient(context);
                                  final respon = await client.postUserLogin(
                                      email, password);
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  if (respon.code == 0) {
                                    var data = UserLogin.fromJson(respon.data);
                                    pref.write(key: "token", value: data.token);
                                    //  print("data user token " + data.token);
                                    //  Navigator.pushReplacement(context, newRoute)
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyStatefulWidget()),
                                    );
                                  } else {
                                    final snackBar = SnackBar(
                                        content:
                                            Text('Email or passwor fail!'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                              child: Text('Login')),
                          SizedBox(height: 30),
                          Text(response)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
