import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Infinite List',
//       theme: new ThemeData(
//           primaryColor: Colors.blue, accentColor: Colors.lightBlue),
//       home: new RandomWords(),
//     );
//   }
// }

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
    

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<int> newEntries = await fakeRequest(_suggestions.length, _suggestions.length + 10);
      List<int> testList = [];
      if (testList.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge -offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }


      setState(() {
        //_suggestions.addAll(generateWordPairs().take(10));
        isPerformingRequest = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _suggestions.addAll(generateWordPairs().take(10));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  //   void initState() {
  //     print('stat state state start');
  //     super.initState();
  //     //setState()
  //     _suggestions.addAll(generateWordPairs().take(10));

  //   // Call the getJSONData() method when the app initializes
  //   //this.getJSONData();
  // }
  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
    // new Scaffold(
    //   appBar: new AppBar(
    //     title: new Text('Infinite List'),
    //     centerTitle: true,
    //     actions: <Widget>[
    //       new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
    //     ],
    //   ),
    //   body: _buildSuggestions(),
    // );
  }

  void _tapNote() {
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
        _tapNote();
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

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(0),
        controller: _scrollController,
        itemCount: _suggestions.length + 1,
        itemBuilder: (context, i) {
          //final item = items[index];

          final index = i ; //~/ 2;
          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));

          // }


          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));
          // }
          if (index == _suggestions.length) {
            
            return _buildProgressIndicator();

          } else {
            // return ListTile(title: new Text("Number $index"));
            final item = _suggestions[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify Widgets.
              key: Key(item.asPascalCase+index.toString()),
              // We also need to provide a function that tells our app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from our data source.
                setState(() {
                  _suggestions.removeAt(index);
                });

                // Then show a snackbar!
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Show a red background as the item is swiped away
              background: Container(color: Colors.red),
              child: ListTile(title: Text('$item')),
            );
          
          
          }


          return _buildRow(_suggestions[index]);
        });
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

}


Future<List<int>> fakeRequest(int from, int to) async {
  return Future.delayed(Duration(seconds: 2), () {
    return List.generate(to - from, (i) => i + from);
  });
}