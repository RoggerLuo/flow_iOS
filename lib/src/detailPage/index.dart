import 'package:flutter/material.dart';
import '../note.dart';
import 'package:flutter_tags/selectable_tags.dart';
import '../http_service.dart';
import '../buildProgressIndicator.dart';
import '../editPage/index.dart';
void routeToDetail(context,{Note note}) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return new DetailPage(note:note);
    }
  ));
}
class DetailPage extends StatefulWidget {
  const DetailPage({
    Key key,
    this.note,
  }) : super(key: key);
  final Note note;
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
  Widget getSelectableTags(_tags){
    return SelectableTags(
      borderSide: BorderSide(width: 1.0, color: Colors.grey[300]),
      // backgroundContainer: Colors.grey[50],
      tags: _tags,
      columns: 3, // default 4
      symmetry: true, // default false
      borderRadius: 4,
      boxShadow:[BoxShadow(color: Colors.white)],
      onPressed: (tag){
        setState(() {
          _filtered_notes = [];
        });
        String tagText = tag.title;
        if(_selected_tags.indexOf(tagText) == -1){
          _selected_tags.add(tagText);
        }else{
          _selected_tags.remove(tagText);
        }
        for (var x = 0; x < _notes.length; x++) {
          Note _note = _notes[x];
          for (var j = 0; j < _note.matchList.length; j++) {
            var currentWord = _note.matchList[j];
            if(_selected_tags.indexOf(currentWord) != -1){
              if(_note.id != widget.note.id){ // 去除当前笔记
                _filtered_notes.add(_note);
              }
            }
          }          
        }
      },
    );
  }
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
    notes.removeAt(0);
    handleKeywords(notes);
    setState(() {
      _notes.addAll(notes);
      _filtered_notes = _notes;
      _isPerformingRequest = false;
    });
  }
  void changeNote(content){
    setState(() {
      _note.content = content;
    });
  }
  @override
  initState(){
    super.initState();
    _note = widget.note;
    getSimilarList(widget.note.id);
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> noteList = [];
    for (var x = 0; x < _filtered_notes.length; x++) {
      noteList.add(Divider(height: 0.0));
      noteList.add(buildNoteRow(_filtered_notes[x],context));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          FlatButton(
            onPressed: () {
              routeToEdit(_scaffoldContext,note:widget.note,changeNote:changeNote); //changeNote
            },
            child: Text('编辑',style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white))
          ),              
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _scaffoldContext = context;

          return ListView(
            children: <Widget>[
          Container( // note content
            // constraints:BoxConstraints(minHeight:100),
            color:Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 28, 16, 0), //all(16.0),
              child: Text(widget.note.content,style:TextStyle(fontSize: 17.0))
            )
          ),
          Container( // note time
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0), //all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:<Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 18, 0, 20), //all(16.0),
                    child: Text(convertToDetailTime(widget.note),style:TextStyle(fontSize: 14.0,color: Colors.grey))
                  ),
              ]),
            ),
            // decoration: BoxDecoration( 
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey[100],
            //       blurRadius: 5.0, // has the effect of softening the shadow
            //       spreadRadius: 1.0, // has the effect of extending the shadow
            //       offset: Offset(
            //         0.0, // horizontal, move right 10
            //         5.0, // vertical, move down 10
            //       ),
            //     )
            //   ],
            //   color: Colors.white,
            // )
          ),
          Container( // gap
            color:Colors.grey[200],
            constraints:BoxConstraints(minHeight:2),
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 2, 0, 2), //all(16.0),
              child: Text('包含相同关键词的笔记',style:TextStyle(fontSize: 14.0,fontWeight:FontWeight.normal,color:Colors.grey)),
            )
          ),
          // Container( // title
          //   color:Colors.white,
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(16, 30, 16, 0), //all(16.0),
          //     child: Text('包含相似关键词的笔记',style:TextStyle(fontSize: 16.0,fontWeight:FontWeight.bold,color: Theme.of(context).accentColor)),
          //   )
          // ),
          Container( // tags
            color:Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 4), //all(16.0),
              child: _tagsWidget
            )
          ),
          Container( 
            color:Colors.white,
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: noteList
              )
            )
          ),
          Container(
            color:Colors.white,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: buildProgressIndicator(_isPerformingRequest)
            )
          ),
          Container( // placeholder
            color:Colors.white,
            constraints:BoxConstraints(minHeight:200),
            child: Text('')
          ),

        ]
          ); 
        }
      )          
    );
  }
}
