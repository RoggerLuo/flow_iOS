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
          ScopedModel.of<IndexModel>(context, rebuildOnChange: true).onScrollBottom();
        }
      }
      return false;
    },
    child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(height: 0.0),
        padding: const EdgeInsets.all(0),
        itemCount: model.notes.length + 1,
        itemBuilder: (context, index) {
          if(model.notes.length == 0){
            model.onScrollBottom();
          }
          if (index == model.notes.length) {
            return buildProgressIndicator(model.isPerformingRequest);
          } else {
            return buildNoteRow(model.notes[index],context);
          }
        }
      )
    
  )
);
    
