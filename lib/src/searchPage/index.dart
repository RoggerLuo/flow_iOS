import 'package:flutter/material.dart';
import '../http_service.dart';
import '../note.dart';
import 'dart:async';
import '../buildProgressIndicator.dart';

Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}
routeToSearch(context,) {
  return Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return ExamplePage();//new SearchListExample();
    }
  ));
}


class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List _notes = [];
  bool showSearchIndicator = false;
  String _searchText = "";

  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( '搜索' );
  String _searchWords = '';
  
  void _searchPressed() async {
    if(_searchWords=='') {
      setState(() {
        _notes = [];
      });
      return;
    }
    setState(() {
      showSearchIndicator = true;
    });
    List<Note> rs = await searchReq(_searchWords);
    setState(() {
      _notes = rs;
      showSearchIndicator = false;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      // centerTitle: true,
      actions: [
        new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
      title: _appBarTitle,
      leading: new IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()=>{
          Navigator.of(context).pop()
        },

      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(height: 0.0),
      padding: const EdgeInsets.all(0),
      itemCount: _notes.length + 1, // 一个是selectable tags, 一个是indicator
      itemBuilder: (context, index) {
        if(index == 0){
          return TextField( // 把 字 体 调 大
            onChanged: (text) {
              setState((){
                _searchWords = text;
              });
            },
            onSubmitted: (text) {//内容提交(按回车)的回调
              _searchPressed();
            },
            style: TextStyle(fontSize: 16,color:Colors.white),
            
            decoration: InputDecoration(
              fillColor: Color(0xFF5C5C5C), 
              filled: true, 
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: Color(0xFF5C5C5C))),  
              contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              hintText: '输入关键字',
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: Colors.grey[100])
              )
            ),
            // obscureText: true,
          );
        }
        if(_notes.length==0){
          return buildProgressIndicator(showSearchIndicator);    
        }
        int noteIndex = index - 1; // 因为第一位被占了 但是+1了
        return buildNoteRow(_notes[noteIndex],context,noteIndex,from:'searchPage',removeNote: (i){
          setState(() {
            _notes.removeAt(i);
          });
        });
      }
    );
  }
}

