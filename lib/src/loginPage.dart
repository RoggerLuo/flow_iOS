import 'package:flutter/material.dart';
import 'http_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
Future<String> routeToLoginPage(context) async {
  return Navigator.of(context).push(new MaterialPageRoute( //<Null>
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
  String loginStatus='';
  void _tapConfirm() async {
    if(loginStatus=='ing') return
    setState(() {
      loginStatus='ing';
    });
    Map rs = await login(username,password);
    setState(() {
      loginStatus='';
    });

    if(rs['status'] == 'error') {
      Fluttertoast.showToast(
        msg: "接口出错",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
        fontSize: 16.0
      );
      return;
    }
    if(rs['errorCode'] == 114) {
      Fluttertoast.showToast(
        msg: "账号或密码错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
        fontSize: 16.0
      );
      return;
    }
    String token = rs['results'];
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
                      padding: EdgeInsets.fromLTRB(16.0, 80.0, 0.0, 0.0),
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
                      TextField( // 把 字 体 调 大
                        onChanged: (text) {
                          setState((){
                            username = text;
                          });
                        },
                        style: TextStyle(fontSize: 20,color:Colors.black),
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
                        style: TextStyle(fontSize: 20,color:Colors.black),
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
                      InkWell(
                        onTap: _tapConfirm,
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: loginStatus=='ing'?Colors.blueGrey:Theme.of(context).primaryColor,
                            elevation: 7.0,
                            child: GestureDetector(
                              child: Center(
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      ),                      
                      SizedBox(height: 40.0),
                    ],
                  )
              ),
            ]
        )
     );
  }
}