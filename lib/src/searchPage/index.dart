import 'package:flutter/material.dart';
import '../note.dart';
// import 'package:flutter_tags/selectable_tags.dart';
// import '../http_service.dart';
// import '../buildProgressIndicator.dart';
// import '../editPage/index.dart';
import 'package:material_search/material_search.dart';
const _list = const [
    'Igor Minar',
    'Brad Green',
    'Dave Geddes',
    'Naomi Black',
    'Greg Weber',
    'Dean Sofer',
    'Wes Alvaro',
    'John Scott',
    'Daniel Nadasi',
];
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}
void routeToSearch(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return DetailPage();
    }
  ));
}
class DetailPage extends StatefulWidget {
  const DetailPage({
    Key key,
  }) : super(key: key);
  @override
  DetailPageState createState() => new DetailPageState();
}
class DetailPageState extends State<DetailPage> {
  bool _isPerformingRequest = false;
  Widget _tagsWidget = Text(''); 
  List<Note> _notes = [];
  List<String> _selected_tags = [];
  List<Note> _filtered_notes = [];
  Note _note;
  BuildContext _scaffoldContext;
  
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> noteList = [];
    for (var x = 0; x < _filtered_notes.length; x++) {
      noteList.add(Divider(height: 0.0));
      noteList.add(buildNoteRow(_filtered_notes[x],context,x));
    }
    noteList.add(Divider(height: 0.0));
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
                        
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _scaffoldContext = context;

          return Text('又问题');
        }
      )          
    );
  }
}
