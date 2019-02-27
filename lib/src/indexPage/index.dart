import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
import '../editPage/index.dart';
import '../note.dart';
import '../searchPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginPage.dart';

class MyHomeState extends State {
  var nameOfApp = "Persist Key Value";
  var counter = 0;
  // define a key to use later
  var key = "counter";
  @override
  void initState() {
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text(nameOfApp),
      ),
      // Body
      body: new Container(
        // Center the content
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                '$counter',
                textScaleFactor: 10.0,
              ),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new RaisedButton(
                  onPressed: (){},
                  child: new Text('Increment Counter')),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new RaisedButton(
                  onPressed: (){},
                  child: new Text('Decrement Counter')),
            ],
          ),
        ),
      ),
    );
  }
}


Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");

}




class IndexPage extends StatefulWidget {
  const IndexPage({
    Key key,
    this.context,
    // this.scaffoldContext
  }) : super(key: key);
  final BuildContext context;
  @override
  createState() => IndexPageState();
}


Widget drawer(context) => Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      UserAccountsDrawerHeader(
        //accountName: Text('roger'),
        accountEmail: Text('luojie.5408@163.com'),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550681609599&di=97e4c32f3462d340cf0bf0f316f9a402&imgtype=0&src=http%3A%2F%2Fdesk.fd.zol-img.com.cn%2Fg5%2FM00%2F02%2F0F%2FChMkJlbK7JeIFhACAArOl2v-eCMAALKjgJtPOEACs6v923.jpg"))
          ),
      ),
      ListTile(
        title: Text("全部笔记"),
        // contentPadding:EdgeInsets.zero ,
        //trailing: Icon(Icons.arrow_downward),
      ),
//            Divider(),

      ListTile(
        title: Text("星标笔记"),
        trailing: new Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ),
      ListTile(
        title: Text("全部笔记(时间倒序)"),
      ),
      ListTile(
        title: Text("我的搜索关键词"),
      ),
      ListTile(
        title: Text("偏好设置"),
        trailing: new Icon(
          Icons.settings,
          color: Colors.grey[300],
        ),

      ),

      // ListTile(
      //   title: Text("drawer page"),
      //   trailing: Icon(Icons.arrow_downward),
      //   onTap: () {
      //     // Update the state of the app
      //     // ...
      //     // Then close the drawer
      //     Navigator.pop(context);
      //   },
      // ),

    ],
  ),
);


// class Content extends StatefulWidget {
//   const Content({
//     Key key,
//     this.context,
//     // this.scaffoldContext
//   }) : super(key: key);
//   final BuildContext context;

//   @override
//   createState() => ContentState();
// }
// class ContentState extends State<Content> {
//   @override
//   initState(){
//     super.initState();
//     routeToLoginPage(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//       return Container(
//         color: Colors.white,
//         child: buildMainList(),            
//       );
//   }
// }

class IndexPageState extends State<IndexPage> {
  BuildContext _bodyContext;
  String token = '';
  String key = 'token';
  @override
  initState(){
    super.initState();
    
    if(token=='') {
      Future.delayed(Duration.zero, () async {
        String _token = await routeToLoginPage(context);
        setState((){
          token = _token;
        });
      });
    }else{
      _loadSavedData(); 
    }
  }
  _loadSavedData() async {
    // Get shared preference instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get value
      token = (prefs.getString(key) ?? '0');
    });
  }

  _onIncrementHit() async {
    // Get shared preference instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Get value
      token = (prefs.getString(key) ?? 0);
    });

    // Save Value
    prefs.setString(key, token);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: new Text('Flow'),
        leading : IconButton(icon: Icon(Icons.list), onPressed: _openDrawer),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed:()=>routeToSearch(_bodyContext)),
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshNotesButton)
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _bodyContext = context;
          return Container(
            color: Colors.white,
            child: buildMainList(),            
          );
        }
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(accentColor: Color(0xff0083F0)),
        child: new FloatingActionButton(
          onPressed: () async {
            int createTime = DateTime.now().millisecondsSinceEpoch~/1000;
            int modifyTime = createTime;
            Note _note = Note(content:'',id:-1,createTime:createTime,modifyTime:modifyTime);
            String rs = await routeToNew(_bodyContext,note:_note,changeNote:(){});
            if(rs == 'success') {
              ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();
              await sleep(300);
              Scaffold.of(_bodyContext).showSnackBar(
                SnackBar(
                  content: Text("新建笔记保存成功"),
                  backgroundColor:Colors.lightGreen
                )
              );
            }
          },
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
  void _openDrawer(){
    Scaffold.of(_bodyContext).openDrawer();
  }
  void _refreshNotesButton() {
    ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();
  }
}  
