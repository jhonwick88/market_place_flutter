import 'package:flutter/material.dart';
import 'package:market_place_flutter/utils/ProgressHUD.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
  }

class _LoginPageState extends State<LoginPage>{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  String response = '';
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _uiLogin(context), inAsyncCall: isApiCallProcess, color: Colors.grey);
  }
  Widget _uiLogin(BuildContext context){
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).accentColor,
        body:
        SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
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
                            style: TextStyle(fontFamily: 'Lobster'),
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            validator: (value) => !value!.contains('@') ? 'Email tidak benar' : null,
                            keyboardType: TextInputType.emailAddress,
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
                            validator: (value) => value!.length < 4 ? "Password minimal 4 karakter": null,
                            obscureText: hidePassword ,
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
                                onPressed: (){
                                  setState((){
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context).accentColor.withOpacity(0.2),
                                icon: Icon(hidePassword? Icons.visibility_off : Icons.visibility),
                              )
                            ),
                          ),
                          SizedBox(height: 30),
                          TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green,
                                side: BorderSide(color: Colors.deepOrange, width: 1),
                                elevation: 20,
                                minimumSize: Size(100, 50),
                                shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () async {

                              },
                              // onPressed: (){
                              //   setState(() {
                              //     if(_formKey.currentState!.validate()){
                              //       isApiCallProcess = true;
                              //     }
                              //
                              //   });
                              // },
                              child: Text(
                                  'Login'
                              )
                          ),
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
        )
    );
  }

}