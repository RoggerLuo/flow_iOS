import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
      title: 'Infinite List',
      theme: new ThemeData(primaryColor: Colors.blue, accentColor: Colors.lightBlue),
      home: IndexPage(),
      )
    );
  }
}
class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Reflection'),
        leading : IconButton(icon: Icon(Icons.list), onPressed: _pressLeftButton),
      ),
      body: buildMainList()
    );
  }
  void _pressLeftButton() {
  }
}
