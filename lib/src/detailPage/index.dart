import 'package:flutter/material.dart';
import '../note.dart';
import 'package:flutter_tags/selectable_tags.dart';
import '../http_service.dart';
import '../buildProgressIndicator.dart';
Widget getSelectableTags(_tags){
  return SelectableTags(
    borderSide: BorderSide(width: 1.0, color: Colors.transparent),
    backgroundContainer: Colors.grey[50],
    tags: _tags,
    columns: 3, // default 4
    symmetry: true, // default false
    borderRadius: 4,
    onPressed: (tag){
      print(tag);
    },
  );
}
final _noteFont = const TextStyle(fontSize: 17.0);
void openAddEntryDialog(context,{Note note}) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return new AddEntryDialog(note:note);
    },
    // fullscreenDialog: true
  ));
}
class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({
    Key key,
    this.note,
  }) : super(key: key);
  final Note note;
  @override
  _SignupPageState createState() => new _SignupPageState();
}
class _SignupPageState extends State<AddEntryDialog> {
  bool _isPerformingRequest = false;
  Widget _tagsWidget = Text(''); 
  List<Note> _notes = [];
  void handleKeywords(List notes){
    Set keywordsSet = Set();
    notes.forEach((note)=>note.matchList.forEach((word)=>keywordsSet.add(word)));
    List keywordsList = keywordsSet.toList();
    List<Tag> tagList = keywordsList.map((el)=>Tag(
      title: el, 
      active: false
    )).toList();
    _tagsWidget = getSelectableTags(tagList);
  }
  void getSimilarList(int noteId) async {    
    setState(() {
      _notes = [];
      _isPerformingRequest = true;
    });
    print('get similar request...');
    List<Note> notes = await getSimilar(noteId); 
    handleKeywords(notes);
    setState(() {
      _notes.addAll(notes);
      _isPerformingRequest = false;
    });
  }
  @override
  initState(){
    super.initState();
    getSimilarList(widget.note.id);
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (var x = 0; x < _notes.length; x++) {
      widgetList.add(Divider(height: 0.0));
      widgetList.add(buildNoteRow(_notes[x],context));
    }
    return  Scaffold(
      appBar: new AppBar(
        title: const Text(''),
        actions: [
          new FlatButton(
            onPressed: () {
              // TODO: Handle save
            },
            child:  new Text('编辑',style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white))
          ),              
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            // color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 0), //all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:<Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(widget.note.content,style:TextStyle(fontSize: 17.0))
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 32, 0, 18), //all(16.0),
                    child: Text(convertToDetailTime(widget.note),style:TextStyle(fontSize: 14.0,color: Colors.grey))
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0), //all(16.0),
                  //   child: Divider(height:0),
                  // )
              ]),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100],
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
              // borderRadius: new BorderRadius.all(Radius.circular(25)),
              // gradient: new LinearGradient(colors:[Colors.green,Colors.blue]),
              color: Colors.white,
            )

          ),
          // Container(
          //   color: Colors.white,
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(16, 32, 16, 18), //all(16.0),
          //     child: Text(convertToDetailTime(widget.note),style:TextStyle(fontSize: 14.0,color: Colors.grey))
          //   )
          // ),
          // Container(
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0), //all(16.0),
          //     child: Divider(height:0),
          //   ),
          // ),

          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 18, 16, 0), //all(16.0),
              child: Text('包含相似关键词的笔记',style:TextStyle(fontSize: 16.0,fontWeight:FontWeight.bold,color: Theme.of(context).accentColor)),
            )
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: _tagsWidget
            )
          ),

          Container(
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: widgetList
              )
            )
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: buildProgressIndicator(_isPerformingRequest)
            )
          ),
        ]
      )          
    );
  }
}
