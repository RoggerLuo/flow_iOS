import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
class IndexPage extends StatefulWidget {
  @override
  createState() => IndexPageState();
}
class IndexPageState extends State<IndexPage> {
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
    ScopedModel.of<IndexModel>(context, rebuildOnChange: true).onScrollBottom();
  }
}  
