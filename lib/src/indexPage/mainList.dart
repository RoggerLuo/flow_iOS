import '../note.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import '../buildProgressIndicator.dart';
import 'package:flutter_tags/selectable_tags.dart';

Widget getSelectableTags(List tagList,context){
  if(tagList.length==0) return buildProgressIndicator(true);//Text('');

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
          return buildNoteRow(model.notes[noteIndex],context,noteIndex);
        }
        if(index == lastIndexInTotal) {
          //int noteCount = noteIndex+1;
          //if(noteCount<20) return null; // 小于一次分页的量也别显示，不用分页了就
          return buildProgressIndicator(model.isPerformingRequest);          
        }
      }
    )
  )
);
    
