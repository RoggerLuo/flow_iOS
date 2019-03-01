import '../note.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import '../buildProgressIndicator.dart';
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
        }
        if (index == model.notes.length) {
          return buildProgressIndicator(model.isPerformingRequest);
        } else {
          return buildNoteRow(model.notes[index],context,index);
          // if(model.notes.length ==1 && model.notes[0].id == -2){
          //   return Text('网络连接错误');
          // }
        }
      }
    )
  )
);
    
