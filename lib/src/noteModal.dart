import 'package:flutter/material.dart';
import 'note.dart';
final _noteFont = const TextStyle(fontSize: 17.0);

void openAddEntryDialog(context,{Note note}) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return new AddEntryDialog(note:note);
    },
    fullscreenDialog: true
  ));
}
class AddEntryDialog extends StatefulWidget {
  // final String _content = '';
  // const AddEntryDialog({this._note});
  const AddEntryDialog({
    Key key,
    this.note,
  }) : super(key: key);
  final Note note;
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}
class AddEntryDialogState extends State<AddEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New entry'),
        actions: [
          new FlatButton(
              onPressed: () {
                //TODO: Handle save
              },
              child:  new Text('SAVE',style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)
                )
              ),              
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(widget.note.content,style:_noteFont),
      )
    );
  }
}