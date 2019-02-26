import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/indexPage/model.dart';
import 'src/indexPage/index.dart';
void main() => runApp(new MyApp2());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<IndexModel>(
      model: IndexModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlowApp',
        theme: new ThemeData(primaryColor: Color(0xFF0083F0), accentColor: Color(0xff0384F0)),
        home: IndexPage(context:context)        
      )
    );
  }
}

  class MyApp2 extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
          title: 'Trial',
          home: Scaffold(
              appBar: AppBar(title: Text('List scroll')), body: new MyHome()));
    }
  }

  class MyHome extends StatelessWidget { // Wrapper Widget
    @override
    Widget build(BuildContext context) {
      Future.delayed(Duration.zero, () => showAlert(context));
      return Container(
        child: Text("Hello world"),
      );
    }

    void showAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("hi"),
              ));
    }
  }