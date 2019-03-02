import 'package:flutter/material.dart';
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
            image: AssetImage('assets/drawerbg.jpg')
          ),//NetworkImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550681609599&di=97e4c32f3462d340cf0bf0f316f9a402&imgtype=0&src=http%3A%2F%2Fdesk.fd.zol-img.com.cn%2Fg5%2FM00%2F02%2F0F%2FChMkJlbK7JeIFhACAArOl2v-eCMAALKjgJtPOEACs6v923.jpg"))
        ),
      ),
      ListTile(
        title: Text("全部笔记"),
        // contentPadding:EdgeInsets.zero ,
        //trailing: Icon(Icons.arrow_downward),
      ),
      //Divider(),
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
        title: Text("个人统计数据"),
      ),
      ListTile(
        title: Text("偏好设置"),
        trailing: new Icon(
          Icons.settings,
          color: Colors.grey[300],
        ),
      ),
    ],
  ),
);

