import 'package:flutter/material.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'theAppTitle',
      home: new Scaffold(
        appBar: new AppBar(
          title:new Text('Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(maxLines:10,keyboardType:TextInputType.multiline),     
        ),
      ),
    ); 
  }
}
