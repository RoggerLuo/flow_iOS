import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detailPage/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'indexPage/model.dart';
import 'dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final _noteFont = const TextStyle(fontSize: 16.0);
class Note {
  String content;
  String id;
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
      id: json['_id'],
      modifyTime: json['modifyTime'],
      createTime: json['createTime'],
      matchList: json['match_list']
    );
  }
}

Widget buildNoteRow(Note note,BuildContext context,int index) {
  void _showSnackBar(String abc){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("dismissed")));
  }
  final alreadySaved = false;//_saved.contains(pair);
  return new Slidable(
    delegate: new SlidableDrawerDelegate(),
    actionExtentRatio: 0.25,
    child: new Container(
      color: Colors.white,
      child: new ListTile(
        
        title: Text(note.content,overflow:TextOverflow.ellipsis,maxLines:1,style:_noteFont),
        subtitle: Text(convertTime(note),style:TextStyle(fontSize: 14.0,color: Colors.grey)),
        trailing: new Icon(
          Icons.star ,
          color: alreadySaved ? Colors.yellow : Colors.grey[100],
        ),
        onTap: () {
        routeToDetail(context,note:note);
      },

      ),
    ),
    actions: <Widget>[
      // new IconSlideAction(
      //   caption: 'Archive',
      //   color: Colors.blue,
      //   icon: Icons.archive,
      //   onTap: () => _showSnackBar('Archive'),
      // ),
      // new IconSlideAction(
      //   caption: 'Share',
      //   color: Colors.indigo,
      //   icon: Icons.share,
      //   onTap: () => _showSnackBar('Share'),
      // ),
    ],
    secondaryActions: <Widget>[
      new IconSlideAction(
        caption: 'More',
        color: Colors.black45,
        icon: Icons.more_horiz,
        onTap: () => _showSnackBar('More'),
      ),
      new IconSlideAction(
        caption: '删除',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () async {
          // _showSnackBar('Delete');
          ConfirmAction rs = await confirmDialog(context,note.content);
          if(rs == ConfirmAction.ACCEPT) {
            ScopedModel.of<IndexModel>(context, rebuildOnChange: true).deleteNote(index);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("已删除"),
              backgroundColor:Colors.lightGreen
            ));
          }

        },
      ),
    ],
  );
  // return Dismissible(
  //   key: Key(note.id.toString()),
  //   onDismissed: (direction) async {
  //     ConfirmAction rs = await confirmDialog(context);
  //     if(rs == ConfirmAction.ACCEPT) {
  //       ScopedModel.of<IndexModel>(context, rebuildOnChange: true).deleteNote(index);
  //       Scaffold.of(context).showSnackBar(SnackBar(content: Text("dismissed")));
  //     }
  //   },
    // Show a red background as the item is swiped away
    // background: Container(color: Colors.red),
    // child: ListTile(
      // title: Text(note.content,overflow:TextOverflow.ellipsis,maxLines:1,style:_noteFont),
      // subtitle: Text(convertTime(note),style:TextStyle(fontSize: 14.0,color: Colors.grey)),
      // onTap: () {
      //   routeToDetail(context,note:note);
      // },
  //   )
  // );
}
String convertToDetailTime(Note note){
  var format = new DateFormat('yyyy-MM-dd HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(note.modifyTime);
  String time = format.format(date);
  return time;
}
String convertTime(Note note){
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(note.modifyTime);
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
