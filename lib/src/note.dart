import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detailPage/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'indexPage/model.dart';
import 'dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'http_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
Widget buildNoteRow(Note note,BuildContext context,int index,{String from,removeNote}) {
  void _toggleStar() async {
    String res;
    if(note.starred==true){
      res = await unstarNote(note);
    }else{
      res = await starNote(note);
    }
    if(res == 'ok') {
      ScopedModel.of<IndexModel>(context, rebuildOnChange: true).toggleStar(index);
    }
  }
  void _deleteNote() async {
    // 弹出dialog问是否删除
    ConfirmAction rs = await confirmDialog(context,note.content);
    if(rs == ConfirmAction.ACCEPT) {
      String res = await deleteNote(note);
      if(res == 'ok') {
        if(from=='detailPage'||from=='searchPage') {
          removeNote(index); // 传入参数
        }else{
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).deleteNote(index);
        }
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("删除成功"),
          backgroundColor:Colors.lightGreen
        ));
      }else{
        Fluttertoast.showToast(
          msg: "删除出错",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 16.0
        );
      }
    }
  }
  return Slidable(
    delegate: SlidableDrawerDelegate(),
    actionExtentRatio: 0.25,
    child: Container(
      color: Colors.white,
      child: ListTile(
        
        title: Text(note.content,overflow:TextOverflow.ellipsis,maxLines:1,style:TextStyle(fontSize: 16.0)),
        subtitle: Text(convertTime(note),style:TextStyle(fontSize: 14.0,color: Colors.grey)),
        trailing: from=='detailPage'?
          IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.star,
              color: note.starred == true ? Colors.yellow : Colors.white,//grey[100],
              // note.starred == true ? Icons.star :Icons.star_border,
            ),
            onPressed: (){},
          ):
          IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.star,
              color: note.starred == true ? Colors.yellow : Colors.grey[100],
              // note.starred == true ? Icons.star :Icons.star_border,
            ),
            onPressed: _toggleStar
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
    secondaryActions: from=='detailPage'?<Widget>[]:<Widget>[
      // new IconSlideAction(
      //   caption: 'More',
      //   color: Colors.black45,
      //   icon: Icons.more_horiz,
      //   onTap: () => _showSnackBar('More'),
      // ),
      new IconSlideAction(
        caption: '删除',
        color: Colors.red,
        icon: Icons.delete,
        onTap: _deleteNote
      ),
    ],
  );
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

class Note {
  String content;
  String id;
  int modifyTime;
  int createTime;
  List matchList;
  bool starred;
  Note({this.matchList, this.content, this.id, this.modifyTime, this.createTime,this.starred});
  
  factory Note.fromJson(Map<String, dynamic> json) {
    
    if(json['match_list']==null) {
      json['match_list'] = [];
    }
    
    return Note(
      content: json['content'].trim(),
      id: json['_id'],
      modifyTime: json['modifyTime'],
      createTime: json['createTime'],
      matchList: json['match_list'],
      starred: json['starred']
    );
  }
}
