import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
final _biggerFont = const TextStyle(fontSize: 18.0);
// ScrollController _scrollController = new ScrollController();
//_scrollController.
Widget _buildProgressIndicator(bool isPerformingRequest) {
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
Widget _buildRow(WordPair pair) {
  return ListTile(
    title: new Text(
      pair.asPascalCase,
      style: _biggerFont,
    ),
    onTap: () {
    },
  );
}

Widget buildMainList(ScrollController _scrollController) {
  return ScopedModelDescendant<IndexModel>(
// var buildMainList = (ScrollController _scrollController) => ScopedModelDescendant<IndexModel>(
    builder: (context, child, model) => ListView.separated(
      controller: _scrollController,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      padding: const EdgeInsets.all(0),
      itemCount: model.suggestions.length + 1,
      itemBuilder: (context, index) {
        if(model.suggestions.length == 0){
          // print('0000');
          model.increment();
        }
        if (index == model.suggestions.length) {
          return _buildProgressIndicator(model.isPerformingRequest);
        } else {
          return _buildRow(model.suggestions[index]);
        }
      }
    )
  );
}


// class RandomWords extends StatefulWidget {
//   @override
//   createState() => new RandomWordsState();
// }

// class RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _saved = new Set<WordPair>();
//   final _biggerFont = const TextStyle(fontSize: 18.0);

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Infinite List'),
//         centerTitle: true,
//         actions: <Widget>[
//           new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(
//       new MaterialPageRoute(
//         builder: (context) {
//           final tiles = _saved.map(
//             (pair) {
//               return new ListTile(
//                 title: new Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final divided = ListTile
//               .divideTiles(
//                 context: context,
//                 tiles: tiles,
//               )
//               .toList();

//           return new Scaffold(
//             appBar: new AppBar(
//               title: new Text('Saved lists'),
//             ),
//             body: new ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return new ListTile(
//       title: new Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: new Icon(
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }

//   Widget _buildSuggestions() {
//     return new ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: (context, i) {
//           if (i.isOdd) return new Divider();
//           final index = i ~/ 2;
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10));
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }
// }