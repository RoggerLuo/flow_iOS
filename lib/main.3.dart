import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:english_words/english_words.dart';
import 'infinite_list.dart' as infinite_list;
void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   createState() => new RandomWordsState();
// }

// class RandomWordsState extends State<MyApp> {
//   final _notes = <Note>[];
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

        leading : IconButton(icon: Icon(Icons.list), onPressed: _pressLeftButton),

      ),
      body: infinite_list.RandomWords()//Text('test')//
    );
  }
}