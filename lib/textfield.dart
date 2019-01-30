import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',            
      home: new Scaffold(
        appBar: new AppBar(
          title:new Text('test'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: <Widget>[
            TextField(decoration: InputDecoration(labelText: 'abccc')),
            TextField(keyboardAppearance:Brightness.dark,maxLines:null,keyboardType:TextInputType.multiline,),
          ],),
        ),
      ),
    );
  }
}
