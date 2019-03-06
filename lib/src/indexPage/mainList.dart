import '../note.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import '../buildProgressIndicator.dart';
import 'package:flutter_tags/selectable_tags.dart';

Widget getSelectableTags(List tagList,context){
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
    fontSize: 15,
    
    borderSide: BorderSide(width: 0.0, color: Colors.white), //grey[300]
    // backgroundContainer: Colors.grey[50],
    tags: data,
    columns: 4, // default 4
    symmetry: true, // default false
    borderRadius: 10,
    alignment:MainAxisAlignment.start,
    boxShadow:[BoxShadow(color: Colors.white)],
    margin: EdgeInsets.all(3) ,//EdgeInsets.fromLTRB(3, 4, 3, 4),
    offset:30,
    textOverflow:TextOverflow.fade,
    onPressed: (tag){
      ScopedModel.of<IndexModel>(context, rebuildOnChange: true).tapTag(tag.title);

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
      itemCount: model.notes.length + 2, // 一个是selectable tags, 一个是indicator
      itemBuilder: (context, index) {
        if(model.notes.length == 0){ // init data
          model.getMoreData(startIdx:0);
          model.fetchKeywords();
        }
        if(index == 0){
          return getSelectableTags(model.keywords,context);
        }
        int noteIndex = index - 1; // 因为第一位被占了 但是+1了
        int lastIndexInTotal = model.notes.length + 2 - 1;
        if(index != lastIndexInTotal) {
          return buildNoteRow(model.notes[noteIndex],context,index);
        }
        if(index == lastIndexInTotal) {
          int noteCount = noteIndex+1;
          if(noteCount<20) return null; // 小于一次分页的量也别显示，不用分页了就
          return buildProgressIndicator(model.isPerformingRequest);          
        }
        // if (index == ((model.notes.length-1)+2) ) {
        //   if(index == 0 ) return null;
        //   if(index > ((20-1) +2 ) ) {
        //     return buildProgressIndicator(model.isPerformingRequest);          
        //   }else{
        //     return null;
        //   }
        // } else {
        //   print(index-1);
        //   if(model.notes.length!=0){
        //     return buildNoteRow(model.notes[index-1],context,index);
        //   }else{
        //     return null;
        //   }
        // }
      }
    )
  )
);
    
