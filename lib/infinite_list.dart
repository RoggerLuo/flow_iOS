import 'package:flutter/material.dart';
import 'dart:async';
import 'note.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

final String url = "http://rorrc.3322.org:6664/notes";

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _notes = <Note>[];
  // final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  
  
  Future<List> getNotes(int pageNum,int pageSize) async {
    var response = await http.get(
        Uri.encodeFull(url+'?pageNum='+pageNum.toString()+'&pageSize='+pageSize.toString()),
        headers: {"Accept": "application/json"}
	  );
    Map _jsonData = json.decode(response.body);
    List data = _jsonData['data'];
    List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
    return notes;
    // print(response.body);
    // setState(() {
    //   var dataConvertedToJSON = json.decode(response.body);
    //   _notes.addAll(dataConvertedToJSON['data']);
    // });
    // return "Successfull";
  }

  _getMoreData(int a) async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<Note> notes = await getNotes(a,10);//(_notes.length, _notes.length + 10);
      _notes.addAll(notes);

      // var notesJson 
      // List<int> testList = [];
      if (notes.isEmpty) {
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
        //_notes.addAll(generateWordPairs().take(10));
        isPerformingRequest = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    // getNotes(1,10);
    // List<Note> notes = await getNotes(1,10);//(_notes.length, _notes.length + 10);
    // _notes.addAll(notes);

    // _notes.addAll(generateWordPairs().take(10));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData(1);
      }
    });

    _getMoreData(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  void _tapNote() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          // final tiles = _saved.map(
          //   (pair) {
          //     return new ListTile(
          //       title: new Text(
          //         pair.asPascalCase,
          //         style: _biggerFont,
          //       ),
          //     );
          //   },
          // );
          // final divided = ListTile
          //     .divideTiles(
          //       context: context,
          //       tiles: tiles,
          //     )
          //     .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved lists'),
            ),
            body: Text('text'),
          );
        },
      ),
    );
  }

  Widget _buildRow(Note note) {

    // final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        note.content,
        style: _biggerFont,
      ),
      // trailing: new Icon(
      //   alreadySaved ? Icons.favorite : Icons.favorite_border,
      //   color: alreadySaved ? Colors.red : null,
      // ),
      onTap: () {
        _tapNote();
        // setState(() {
        //   if (alreadySaved) {
        //     _saved.remove(pair);
        //   } else {
        //     _saved.add(pair);
        //   }
        // });
      },
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(0),
        controller: _scrollController,
        itemCount: _notes.length + 1,
        itemBuilder: (context, i) {
          final index = i ; //~/ 2;
          if (index == _notes.length) {
            
            return _buildProgressIndicator();

          } else {
            // return ListTile(title: new Text("Number $index"));
            final note = _notes[index];
            final content = note.content.trim(); // 显示第二行
            // final modifyTime = DateTime.fromMillisecondsSinceEpoch(note.modifyTime * 1000);
            // var formatter = DateFormat('yyyy-MM-dd');
            // String formattedTime = formatter.format(modifyTime);

            
            var now = new DateTime.now();
            var format = new DateFormat('HH:mm a');
            var date = new DateTime.fromMillisecondsSinceEpoch(note.modifyTime * 1000);
            var diff = now.difference(date);
            var time = '';

            if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
              time = format.format(date);
            } else if (diff.inDays > 0 && diff.inDays < 7) {
              if (diff.inDays == 1) {
                time = diff.inDays.toString() + '天前';
              } else {
                time = diff.inDays.toString() + '天前';
              }
            } else {
              if (diff.inDays == 7) {
                time = (diff.inDays / 7).floor().toString() + '周前';
              } else {

                time = (diff.inDays / 7).floor().toString() + '周前';
              }
            }

            return Dismissible(
              key: Key(note.id.toString()),
              onDismissed: (direction) {
                setState(() {
                  _notes.removeAt(index);
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$note dismissed")));
              },
              // Show a red background as the item is swiped away
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(content,overflow:TextOverflow.ellipsis,maxLines:1),
                subtitle: Text(time)
              ),
            );
          
          
          }


          //return _buildRow(_notes[index]);
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