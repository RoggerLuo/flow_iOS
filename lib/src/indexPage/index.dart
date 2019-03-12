import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
import '../editPage/index.dart';
import '../note.dart';
import '../searchPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginPage.dart';
import 'drawer.dart';
import 'dart:async'; // for using future
import '../http_service.dart';
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}
class IndexPage extends StatefulWidget {
  @override
  createState() => IndexPageState();
}
class IndexPageState extends State<IndexPage> {
  BuildContext _bodyContext;
  String token = '';
  String key = 'token';

  @override
  initState() {
    super.initState();
    _login();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Flow';
    if(ScopedModel.of<IndexModel>(context, rebuildOnChange: true).isReverse){
      title = '时间倒序';
    }
    if(ScopedModel.of<IndexModel>(context, rebuildOnChange: true).isStar){
      title = '星标笔记';
    }

    return Scaffold(
      drawer: drawer(context),

      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _bodyContext = context;
          if(token=='') return Text('');
          return Container(
            color: Colors.white,
            child: buildMainList(),            
          );
        }
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(accentColor: Theme.of(context).primaryColor), //Color(0xff0083F0)
        child: new FloatingActionButton(
          onPressed: _pressFloatButton,
          child: new Icon(Icons.add),
        ),
      ),

      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        leading : IconButton(icon: Icon(Icons.list), onPressed: _openDrawer),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed:() async {
            await routeToSearch(_bodyContext);
            _refreshNotesButton();
          }),
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshNotesButton)
        ],
      ),
    );
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
    setState(() {
      token = (prefs.getString(key) ?? ''); // Get value
    });
    
    if(token=='') { // 如果没有登陆
      Future.delayed(Duration.zero, () async {
        String _token = await routeToLoginPage(context);
        setState((){
          token = _token;
        });
        prefs.setString(key, token); // Save Value
      });
      return;
    }else { // 正常验证
      String rs = await verifyAuth();
      if(rs == 'error') {
        Future.delayed(Duration.zero, () async {
        String _token = await routeToLoginPage(context);
        setState((){
          token = _token;
        });
        prefs.setString(key, token); // Save Value
      });
      }
    }
  }
  
  void _openDrawer(){
    Scaffold.of(_bodyContext).openDrawer();
  }
  
  void _refreshNotesButton() {
    ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();
  }
  
  // 首页的加号圆形按钮
  void _pressFloatButton() async {
    int createTime = DateTime.now().millisecondsSinceEpoch~/1000;
    int modifyTime = createTime;

    Note _note = Note(content:'',id:'_new',createTime:createTime,modifyTime:modifyTime);
    String rs = await routeToNew(_bodyContext,note:_note,changeNote:(){});
    
    if(rs == 'ok') {

      ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();     
      await sleep(400); // 等编辑框完全退出屏幕

      Scaffold.of(_bodyContext).showSnackBar(
        SnackBar(
          content: Text("新建笔记保存成功"),
          backgroundColor:Colors.lightGreen
        )
      );
    }
  }
}  
