import 'package:flutter/material.dart';
import 'http_service.dart';
Future<String> routeToLoginPage(context) async {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return new SignupPage();
    }
  ));
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String username='';
  String password='';
  void _tapConfirm() async {
    String token = await login(username,password);
    Navigator.of(context).pop(token);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 50.0, 0.0, 0.0),
                      child: Text(
                        '登录',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(118.0, 45.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0083F0)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            username = text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: ' 账号(Email) ',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor)
                          )
                        ),
                        obscureText: true,
                      ),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            password = text;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: ' 密码 ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
                        obscureText: true,
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: _tapConfirm,
                            child: Center(
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )
                      ),
                      // SizedBox(height: 20.0),
                      // Container(
                      //   height: 40.0,
                      //   color: Colors.transparent,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Colors.black,
                      //             style: BorderStyle.solid,
                      //             width: 1.0),
                      //         color: Colors.transparent,
                      //         borderRadius: BorderRadius.circular(20.0)),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pop();
                      //       },
                      //       child: Center(
                      //         child: Text('',
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontFamily: 'Montserrat')),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 40.0),

                    ],
                  )
              ),
            ]
        )
     );
  }
}