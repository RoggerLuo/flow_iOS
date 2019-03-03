import 'package:flutter/material.dart';
import 'http_service.dart';
import 'dart:async';
import 'registerPage.dart';
import 'toast.dart';

Future<String> routeToLoginPage(context) async {
  return Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {

      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SignupPage()
      );
      // return new SignupPage();
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
    if(username=='') {
      warning("账号不能为空");
      return;
    }
    if(password==''){
      warning("密码不能为空");
      return;
    }
    if(loginStatus=='ing') return
    setState(() {
      loginStatus='ing';
    });
    Map rs = await login(username,password);
    setState(() {
      loginStatus='';
    });
    if(rs['status'] == 'error') {
      warning("接口出错");
      return;
    }
    if(rs['errorCode'] == 114) {
      warning("账号或密码错误");
      return;
    }
    String token = rs['results'];
    Navigator.of(context).pop(token);    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Builder( // 使用builder是为了暴露出context
          builder: (_context) {
            return ListView(
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
                        padding: EdgeInsets.fromLTRB(118.0, 78.0, 0.0, 0.0),
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
                        style: TextStyle(fontSize: 18,color:Colors.black),
                        decoration: InputDecoration(
                          labelText: ' 账号/Email',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor)
                          )
                        ),
                        // obscureText: true,
                      ),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            password = text;
                          });
                        },
                        style: TextStyle(fontSize: 18,color:Colors.black),
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
                      SizedBox(height: 50.0),
                      InkWell(
                        onTap: _tapConfirm,
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.grey,
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
                      SizedBox(height: 25.0),
                      InkWell(
                        onTap: () async {
                          var rs = await routeToRegisterPage(_context);
                          if(rs=='ok') {
                            await sleep(400); // 等编辑框完全退出屏幕

                            Scaffold.of(_context).showSnackBar(
                              SnackBar(
                                content: Text("注册成功"),
                                backgroundColor:Colors.lightGreen
                              )
                            );

                          }
                        },
                        child: Text(
                          '没有账号？注册一个',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                    ],
                  )
                ),
              ]
            );
          }
        )
     );
  }
}