import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
class IndexPage extends StatefulWidget {
  @override
  createState() => IndexPageState();
}
class IndexPageState extends State<IndexPage> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ScopedModel.of<IndexModel>(context, rebuildOnChange: true).increment();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Reflection'),
        leading : IconButton(icon: Icon(Icons.list), onPressed: _pressLeftButton),
      ),
      body: buildMainList(_scrollController)
    );
  }
  void _pressLeftButton() {
    ScopedModel.of<IndexModel>(context, rebuildOnChange: true).increment();
  }
}  
