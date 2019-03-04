import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';

Widget drawer(context) => Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(''),
        accountEmail: Text('luojie.5408@163.com'),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/drawerbg.jpg')
          ),
        ),
      ),
      ListTile(
        onTap: (){
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).switchStarList();
          Navigator.of(context).pop();
        },
        title: Text("星标笔记"),
        trailing: new Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ),

      ListTile(
        onTap: (){
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).switchAllList();
          Navigator.of(context).pop();
        },

        title: Text("全部笔记"),
        // contentPadding:EdgeInsets.zero ,
        trailing: Icon(Icons.subject),
      ),
      //Divider(),
      ListTile(
        onTap: (){
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).switchReverseList();
          Navigator.of(context).pop();
        },

        title: Text("全部笔记(时间倒序)"),
        trailing: Icon(Icons.subject,textDirection: TextDirection.rtl),
                  

      ),
      ListTile(
        title: Text("我的搜索关键词"),
        trailing: Icon(
          Icons.lightbulb_outline,
          // color: Colors.grey[300],
        ),
      ),
      ListTile(
        title: Text("个人统计数据"),
        trailing: Icon(
          Icons.show_chart,
          // color: Colors.grey[300],
        )
      ),
      ListTile(
        title: Text("设置"),
        trailing: new Icon(
          Icons.settings,
          // color: Colors.grey[300]
        ),
      ),

    ],
  ),
);

