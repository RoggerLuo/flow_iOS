import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/indexPage/model.dart';
import 'src/indexPage/indexPage.dart';
// import 'mainList.dart';
// import 'infinite_list.dart';
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<IndexModel>(
      model: IndexModel(),
      child: MaterialApp(
        title: 'Infinite List',
        theme: new ThemeData(primaryColor: Colors.blue, accentColor: Colors.lightBlue),
        home:  IndexPage()
      )
    );
  }
}
