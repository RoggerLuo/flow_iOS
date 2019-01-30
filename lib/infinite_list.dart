import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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
    
  @override
    void initState() {
      print('stat state state start');
      super.initState();
      //setState()
      _suggestions.addAll(generateWordPairs().take(10));

    // Call the getJSONData() method when the app initializes
    //this.getJSONData();
  }
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
        itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          //final item = items[index];

          final index = i ; //~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));

          }

          final item = _suggestions[index];

          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));
          // }

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


          return _buildRow(_suggestions[index]);
        });
  }


}
