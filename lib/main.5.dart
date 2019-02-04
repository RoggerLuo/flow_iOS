import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'src/indexPage/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/indexPage/mainList.dart';

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Infinite List demo',
      theme: new ThemeData(
          primaryColor: Colors.blue, accentColor: Colors.lightBlue),
      home: ScopedModel<IndexModel>(
        model: IndexModel(),
        child: new RandomWords(),
      )
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // ScopedModel.of<IndexModel>(context, rebuildOnChange: true).increment();
      }
    });
  }
// _scrollController.animateTo(i * _ITEM_HEIGHT, duration: new Duration(seconds: 2), curve: Curves.ease);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reflection'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(_scrollController),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved lists'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions(ScrollController _scrollController) {
    return ScopedModelDescendant<IndexModel>(
      builder: (context, child, model) => NotificationListener(
        onNotification:(noti){ 
          if(noti is ScrollUpdateNotification){
            if (noti.metrics.pixels == noti.metrics.maxScrollExtent) {
              print('end');
              // ScopedModel.of<IndexModel>(context, rebuildOnChange: true).increment();
            }
          }
          return false;
        },
        child:ListView.separated(
          padding: const EdgeInsets.all(16.0),
          // controller: _scrollController,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: model.notes.length,// + 1,
          itemBuilder: (context, i) {
            final index = i ;//~/ 2;
            return _buildRow(model.notes[index]);
          }
        )
      )
    );
  }
}