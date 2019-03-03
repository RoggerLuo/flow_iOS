import 'package:flutter/material.dart';
import 'http_service.dart';
import 'toast.dart';

routeToRegisterPage(context) {
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
  String passwordConfirm='';
  void _register() async {
    if(username=='') {
      warning("账号不能为空");
      return;
    }
    if(password==''){
      warning("密码不能为空");
      return;
    }
    if(password.length<6){
      warning("密码不能小于6位");
      return;
    }
    if(username.length<6){
      warning("账号不能小于6位");
      return;
    }
    if(username.length>50){
      warning("账号不能大于50位");
      return;
    }
    if(username.length>30){
      warning("密码不能大于30位");
      return;
    }

    if(password == passwordConfirm) {
      var rs = await postRegister(username,password);
      if(rs == 'error') {
        warning("出现未知错误，请重试");
        return ;
      }
      if(rs == 'duplicated') {
        warning("账号已存在");
        return ;
      }
      if(rs == 'ok') {
        Navigator.of(context).pop('ok');
      }
    }else{
      warning("两次密码输入不一致");
    }
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
                      padding: EdgeInsets.fromLTRB(16.0, 45.0, 0.0, 0.0),
                      child: Text(
                        '注册',
                        style: TextStyle(
                          fontSize: 60.0, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(118.0, 40.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green //Color(0xFF0083F0)
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
                      // TextField(
                      //   decoration: InputDecoration(
                      //       labelText: 'Full Name',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       // hintText: 'EMAIL',
                      //       // hintStyle: ,
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            username = text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '电子邮件地址(作为账号)',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        // obscureText: true,
                      ),
                      // SizedBox(height: 10.0),
                      // TextField(
                      //   decoration: InputDecoration(
                      //       labelText: '再次输入Email',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      // SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            password = text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '输入密码',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      TextField(
                        onChanged: (text) {
                          setState((){
                            passwordConfirm = text;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: '再次输入密码',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      // SizedBox(height: 10.0),
                      // TextField(
                      //   decoration: InputDecoration(
                      //       labelText: 'Phone Number ',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      //   obscureText: true,
                      // ),
                      SizedBox(height: 50.0),
                      InkWell(
                        onTap: _register,
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.grey,
                            color: Theme.of(context).primaryColor,
                            elevation: 7.0,
                            child: GestureDetector(
                              // onTap:  _register,
                              child: Center(
                                child: Text(
                                  '注册',
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
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop('cancel');
                            },
                            child: Center(
                              child: Text('返回',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                                )
                              ),
                            ),
                          ),
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