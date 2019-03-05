import '../note.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import '../buildProgressIndicator.dart';
import 'package:flutter_tags/selectable_tags.dart';

Widget getSelectableTags(List tagList){
  if(tagList.length==0) return Text('');

  var data = tagList.map((el)=>Tag(
    title: el, 
    active: false
  )).toList();

  // if(tagList.length==0) return Text('');
  // List<Tag> _tags = tagList.map((el)=>Tag(
  //   title: el, 
  //   active: false
  // )).toList();

  return SelectableTags(
    borderSide: BorderSide(width: 1.0, color: Colors.grey[300]),
    // backgroundContainer: Colors.grey[50],
    tags: data,
    columns: 3, // default 4
    symmetry: true, // default false
    borderRadius: 4,
    boxShadow:[BoxShadow(color: Colors.white)],
    onPressed: (tag){
      // setState(() {
      //   _filtered_notes = [];
      // });
      // String tagText = tag.title;
      // if(_selected_tags.indexOf(tagText) == -1){
      //   _selected_tags.add(tagText);
      // }else{
      //   _selected_tags.remove(tagText);
      // }
      // if(_selected_tags.length == 0) {
      //   setState(() {
      //     _filtered_notes = _notes;
      //   });
      //   return;
      // }
      // for (var x = 0; x < _notes.length; x++) {
      //   Note _note = _notes[x];
      //   bool thisNoteIncludesAllKeywords = true;
      //   bool thisNoteIsNotCurrentNote = true;
      //   for (var j = 0; j < _selected_tags.length; j++) {
      //     var currentWord = _selected_tags[j];
      //     if(_note.matchList.indexOf(currentWord) == -1){
      //       thisNoteIncludesAllKeywords = false;
      //     }
      //     if(_note.id == widget.note.id){ // 去除当前笔记
      //       thisNoteIsNotCurrentNote = false;            
      //     }
      //   }
      //   if(thisNoteIncludesAllKeywords && thisNoteIsNotCurrentNote) {
      //     _filtered_notes.add(_note);
      //   }
      // }
    },
  );
}
var buildMainList = () => ScopedModelDescendant<IndexModel>(
  builder: (context, child, model) => NotificationListener(
    onNotification:(noti){ 
      if(noti is ScrollUpdateNotification){
        if (noti.metrics.pixels == noti.metrics.maxScrollExtent) {
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).getMoreData(startIdx: model.notes.length);
        }
      }
      return false;
    },
    child: ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(height: 0.0),
      padding: const EdgeInsets.all(0),
      itemCount: model.notes.length + 1,
      itemBuilder: (context, index) {
        if(model.notes.length == 0){ // init data
          model.getMoreData(startIdx:0);
          model.fetchKeywords();
        }
        print(index);
        if(index == 0){
          return getSelectableTags(model.keywords);
        }
        if (index == model.notes.length) {
          if(index>9 || index != 0) {
            return buildProgressIndicator(model.isPerformingRequest);
          }else{
            return null;
          }
        } else {
          return buildNoteRow(model.notes[index],context,index);
        }
      }
    )
  )
);
    
