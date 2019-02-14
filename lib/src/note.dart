import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detailPage/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'indexPage/model.dart';

final _noteFont = const TextStyle(fontSize: 16.0);
class Note {
  String content;
  int id;
  int modifyTime;
  int createTime;
  List matchList;
  Note({this.matchList, this.content, this.id, this.modifyTime, this.createTime});
  factory Note.fromJson(Map<String, dynamic> json) {
    if(json['match_list']==null) {
      json['match_list'] = [];
    }
    return Note(
      content: json['content'].trim(),
      id: json['id'],
      modifyTime: json['modify_time'],
      createTime: json['create_time'],
      matchList: json['match_list']
    );
  }
}

Widget buildNoteRow(Note note,BuildContext context,int index) {
  
  return Dismissible(
    key: Key(note.id.toString()),
    onDismissed: (direction) {
      ScopedModel.of<IndexModel>(context, rebuildOnChange: true).deleteNote(index);

      // setState(() {
      //   _notes.removeAt(index);
      // });
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("dismissed")));
    },
    // Show a red background as the item is swiped away
    background: Container(color: Colors.red),
    child: ListTile(
      title: Text(note.content,overflow:TextOverflow.ellipsis,maxLines:1,style:_noteFont),
      subtitle: Text(convertTime(note),style:TextStyle(fontSize: 14.0,color: Colors.grey)),
      onTap: () {
        routeToDetail(context,note:note);
      },
    )
  );
}
String convertToDetailTime(Note note){
  var format = new DateFormat('yyyy-MM-dd HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(note.modifyTime * 1000);
  String time = format.format(date);
  return time;
}
String convertTime(Note note){
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
  return time;
}
