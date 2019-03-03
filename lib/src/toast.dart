import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// enum MyToast { CANCEL, warning }
// success(){

// }
warning(msg){
  Fluttertoast.showToast(
    msg:msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 2,
    backgroundColor: Colors.orangeAccent,
    textColor: Colors.white,
    fontSize: 18.0
  );
}  
