import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> confirmDialog(BuildContext context,String content) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('删除笔记'),
        content: Text('确定要删除"'+content.trim().replaceAll(RegExp(r'\n'),' ').substring(0, 15)+'..."吗?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('取消',style:TextStyle(fontSize: 16.0)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('确定',style:TextStyle(fontSize: 16.0)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}
// Future confirmDialog(BuildContext context){
   
//   return _asyncConfirmDialog(context);
// }
