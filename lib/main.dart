import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:english_words/english_words.dart';
import 'infinite_list.dart' as infinite_list;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: IndexPage(),
    );
  }
}

class IndexPage extends StatelessWidget {
    void _pressLeftButton() {

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reflection"),

        leading : new IconButton(icon: new Icon(Icons.list), onPressed: _pressLeftButton),

      ),
      body: new infinite_list.RandomWords()//Text('test')//
    );
  }
}