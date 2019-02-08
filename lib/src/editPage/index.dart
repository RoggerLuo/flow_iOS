import 'package:flutter/material.dart';
import '../note.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

void routeToEdit(context,{Note note}) {
  Navigator.of(context).push(MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return EditPage(note:note);
    },
    fullscreenDialog: true
  ));
}
class EditPage extends StatefulWidget {
  const EditPage({
    Key key,
    this.note,
  }) : super(key: key);
  final Note note;
  @override
  EditPageState createState() => new EditPageState();
}
class EditPageState extends State<EditPage> {  
  FocusNode _nodeText1 = FocusNode();
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('编辑'),
        actions: [
          new FlatButton(
              onPressed: () {
                //TODO: Handle save
              },
              child: new Text('保存',
                style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white))),
        ],
      ),
      body: FormKeyboardActions(
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
            // TextField(decoration: InputDecoration(labelText: 'abccc')),
            TextField(
              // keyboardAppearance:Brightness.dark,
              focusNode: _nodeText1,
              autofocus:true,
              maxLines:null,
              keyboardType:TextInputType.multiline,
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: '开始写笔记...'
              ),
            ),
          ],),
        ),
        // TextField(
        //   keyboardType: TextInputType.multiline,
        //   maxLines: 16,
        //   focusNode: _nodeText1,
        //   decoration: InputDecoration(
        //     hintText: "Input Number",
        //   ),
        // ),
      ),

      
      
    );
  }
}
