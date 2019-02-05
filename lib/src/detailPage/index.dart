import 'package:flutter/material.dart';
import '../note.dart';
import 'package:flutter_tags/selectable_tags.dart';
import '../http_service.dart';
import '../note.dart';
// import 'package:scoped_model/scoped_model.dart';
final _noteFont = const TextStyle(fontSize: 17.0);
void openAddEntryDialog(context,{Note note}) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      // return ScopedModelDescendant<DetailModel>(
      //     builder: (context, child, model) => AddEntryDialog(note:note)
      // );
      return new AddEntryDialog(note:note);
    },
    // fullscreenDialog: true
  ));
}
class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({
    Key key,
    this.note,
  }) : super(key: key);
  final Note note;
  @override
  _SignupPageState createState() => new _SignupPageState();
}
class _SignupPageState extends State<AddEntryDialog> {
  List<Note> _notes = [];
  
  List<Tag> _tags=[
    Tag(
      id: 1,
      title: '测试', 
      active: true
    ),
    Tag(
      id: 3,
      title: '三个字', 
      active: true
    ),
    Tag(
      id: 5,
      title: '123itemasdfasdfasdftitle', 
      active: true
    ),
    Tag(
      id: 8,
      title: 'itemasdfasdfasdftitle', 
      active: true
    ),
    Tag(
      id: 9,
      title: '123itemasdfasdfasdftitle', 
      active: true
    ),
    Tag(
      id: 2,
      title: 'item.title22', 
      active: false
    )
  ];
  void getSimilarList(int noteId) async {    
    setState(() {
      _notes = [];
    });
    print('get similar request...');
    List<Note> notes = await getSimilar(noteId);//(_notes.length, _notes.length + 10);
    setState(() {
      _notes.addAll(notes);
    });
    // return _notes;
    // notifyListeners();
  }
  @override
  initState(){
    super.initState();
    getSimilarList(widget.note.id);
/* ScopedModelDescendant<DetailModel>(
      builder: (context, child, model) => */
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: const Text(''),
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
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(widget.note.content,style:_noteFont),
            )
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: SelectableTags(
                backgroundContainer: Colors.grey[50],
                tags: _tags,
                columns: 4, // default 4
                symmetry: true, // default false
                borderRadius: 4,
                onPressed: (tag){
                  print(tag);
                },
              )
            )
          ),
          
          Container(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children:  _notes.map((note)=>buildNoteRow(note,context)).toList()
                  // Text('asdf'),
                  // Text('asdf22')

                // ]
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0,bottom:35.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Email Address ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Confirm Email Address ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Phone Number ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 50.0),
                        Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text('Go Back',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ]
            )
          
      );
  }
}

class AddEntryDialogState extends State<AddEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(''),
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
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Text('We move under cover and we move as one'),
    Text('Through the night, we have one shot to live another day'),
    Text('We cannot let a stray gunshot give us away'),
    Text('We will fight up close, seize the moment and stay in it'),
    Text('It’s either that or meet the business end of a bayonet'),
    Text('The code word is ‘Rochambeau,’ dig me?'),
    Expanded(
      child: Text('Rochambjjjjjjjeau!', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
    )
  ],
)

// Row(
//           children: <Widget>[
//             // Row(children: <Widget>[
//             //     const FlutterLogo(),
//             //     const Expanded(
//             //       child: Text('Flutter\'s hot reload helps you quickly and easily experiment, build UIs, add features, and fix bug faster. Experience sub-second reload times, without losing state, on emulators, simulators, and hardware for iOS and Android.'),
//             //     ),
//             //     const Icon(Icons.sentiment_very_satisfied),          ],
//             // ),
//             const FlutterLogo(),
//             const Expanded(
//               child: Text('Flutter\'s hot reload helps you quickly and easily experiment, build UIs, add features, and fix bug faster. Experience sub-second reload times, without losing state, on emulators, simulators, and hardware for iOS and Android.'),
//             ),
//             const Icon(Icons.sentiment_very_satisfied),          ],
//         )
        
        //Text(widget.note.content,style:_noteFont),
      )
    );
  }
}