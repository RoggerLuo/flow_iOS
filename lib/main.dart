import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/indexPage/model.dart';
import 'src/indexPage/index.dart';
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<IndexModel>(
      model: IndexModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlowApp',
        theme: new ThemeData(primaryColor: Color(0xFF0083F0), accentColor: Color(0xff0384F0)),
        home: IndexPage()        
      )
    );
  }
}