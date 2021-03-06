import 'package:flutter/material.dart';
import '../note.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../http_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../buildProgressIndicator.dart';
import 'dart:async';
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}

Future<String> routeToNew(context,{Note note,changeNote}) async {
  return Navigator.of(context).push(MaterialPageRoute( //<Null>
    builder: (BuildContext context2) {
      return EditPage(note:note,changeNote:changeNote);
    },
    fullscreenDialog: true
  ));
}
Future<String> routeToEdit(context,{Note note,changeNote}) async {
  return Navigator.of(context).push(MaterialPageRoute( //<Null>
    builder: (BuildContext context2) {
      return EditPage(note:note,changeNote:changeNote);
    },
    fullscreenDialog: true
  ));
}
class EditPage extends StatefulWidget {
  const EditPage({
    Key key,
    this.note,
    this.changeNote,
  }) : super(key: key);
  final Note note;
  final changeNote;
  @override
  EditPageState createState() => new EditPageState();
}
class EditPageState extends State<EditPage> {  
  FocusNode _nodeText1 = FocusNode();
  bool spin = false;
  void focus(){
    FocusScope.of(context).requestFocus(_nodeText1);
  }
  final myController = TextEditingController();
  Note _note;
  bool saved = true;

  void _goBack() async {
    
    if(saved){
      Navigator.of(context).pop('no changes happen');
      return ;
    }
    if(spin) return;
    setState(() {
      spin = true;
      
    });
    //await sleep(3000);
    if(widget.note.id=='_new') { //判断是新建还是编辑
      if(_note.content==''){ // 新建的情况下 如果没有编辑就退出
        Navigator.of(context).pop('no changes happen');
        return;
      }
      String rs = await createNote(_note);
      if(rs == 'error') {
        Fluttertoast.showToast(
          msg: "新建出错",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 16.0
        );
      }else{
        saved = true;
        Navigator.of(context).pop('ok');
      }
    }else{ // edit
      String rs = await modifyNote(widget.note);
      if(rs == 'ok') {
        saved = true;
        Navigator.of(context).pop('ok');
      }
    }
    setState(() {
      spin = false;    
    }); 
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  initState(){
    super.initState();
    myController.text = widget.note.content;
    _note = widget.note;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑'),
        
        leading : InkWell(
          onTap: _goBack,
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_back_ios),
              // const FlutterLogo(),
              Text('完成',style: TextStyle(fontSize: 16)),
              // const Icon(Icons.sentiment_very_satisfied),
            ],
          ),
        ),

        // IconButton(
        //   icon: Icon(Icons.close), 
        //   onPressed: _goBack,
        // ),
        
        actions: [
          // FlatButton(
          //   onPressed: () {
          //     return ;
          //   },
          //   child: Text(
          //     '',//'保存',
          //     style: Theme
          //       .of(context)
          //       .textTheme
          //       .subhead
          //       .copyWith(color: Colors.white)
          //   )
          // ),
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) { 
          return Stack(
            children: <Widget>[
              spin?buildProgressIndicator(true):Text(''),
          // _scaffoldContext = context;
          FormKeyboardActions(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: Colors.transparent, //Colors.grey[200],//
            nextFocus: false,
            actions: [
              KeyboardAction(
                focusNode: _nodeText1,
                closeWidget: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 2, 10.0, 10.0),//all(8.0)
                  child: Icon(Icons.keyboard),
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: ListView(children: <Widget>[
                TextField(
                  onChanged: (text) {
                    saved = false;
                    _note.content = text;
                    widget.changeNote(text); //myController
                  },
                  controller: myController,
                  // keyboardAppearance:Brightness.dark,
                  focusNode: _nodeText1,
                  autofocus:true,
                  maxLines:null,
                  keyboardType:TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '开始写笔记...'
                  ),
                ),
                InkWell(
                  onTap: (){
                    focus();
                  },
                  child: Container(
                    // color:Colors.grey[200],
                    constraints:BoxConstraints(minHeight:450),
                    child:Text(''),
                  )
                ),
              ],
            ),
          ),
        )
          
          
          ]
          );
          
        // TextField(
        //   keyboardType: TextInputType.multiline,
        //   maxLines: 16,
        //   focusNode: _nodeText1,
        //   decoration: InputDecoration(
        //     hintText: "Input Number",
        //   ),
        // ),
      }),
    );
  }
}
