import 'package:flutter/material.dart';
import '../note.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../http_service.dart';

Future<String> routeToNew(context,{Note note,changeNote}) async {
  return Navigator.of(context).push(MaterialPageRoute( //<Null>
    builder: (BuildContext context2) {
      return EditPage(note:note,changeNote:changeNote,scaffoldContext:context);
    },
    fullscreenDialog: true
  ));
}
void routeToEdit(context,{Note note,changeNote}) {
  Navigator.of(context).push(MaterialPageRoute( //<Null>
    builder: (BuildContext context2) {
      return EditPage(note:note,changeNote:changeNote,scaffoldContext:context);
    },
    fullscreenDialog: true
  ));
}
class EditPage extends StatefulWidget {
  const EditPage({
    Key key,
    this.note,
    this.changeNote,
    this.scaffoldContext
  }) : super(key: key);
  final Note note;
  final changeNote;
  final BuildContext scaffoldContext;
  @override
  EditPageState createState() => new EditPageState();
}
class EditPageState extends State<EditPage> {  
  FocusNode _nodeText1 = FocusNode();
  void focus(){
    FocusScope.of(context).requestFocus(_nodeText1);
  }
  final myController = TextEditingController();
  var _scaffoldContext; //为了使用snack，必须使用scaffold的context，而不是更上层的
  Note _note;
  bool saved = true;
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
        leading : IconButton(icon: Icon(Icons.close), onPressed: () async {
          if(saved){
            Navigator.pop(context);
            return ;
          }
          if(widget.note.id==-1) {
            int rs = await createNote(_note);
            if(rs != -1) {
              saved = true;
              // Navigator.pop(context);
              Navigator.of(context).pop('success');
            }
            return ;
          }
          String rs = await modifyNote(widget.note);
          if(rs == 'success') {
            saved = true;
            Navigator.pop(context);
            Scaffold.of(widget.scaffoldContext).showSnackBar(
              SnackBar(
                content: Text("保存成功"),
                backgroundColor:Colors.lightGreen
              )
            );
          }
        }),
        actions: [
          FlatButton(
            onPressed: () {
              return ;
              // if(_buttonText==''){
              //   return ;
              // }
              // widget.changeNote(myController.text);
              // setState((){
              //   _buttonText = '';
              // });
            },
            child: Text(
              '',//'保存',
              style: Theme
                .of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white)
            )
          ),
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) { 
          _scaffoldContext = context;
          return FormKeyboardActions(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: Colors.transparent, //Colors.grey[200],//
            nextFocus: false,
            actions: [
              KeyboardAction(
                focusNode: _nodeText1,
                closeWidget: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 2, 10.0, 10.0),//all(8.0)
                  child: Icon(Icons.details),
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
