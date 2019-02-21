import 'package:flutter/material.dart';
import '../note.dart';
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}
void routeToDetail(context,) {
  Navigator.of(context).push(new MaterialPageRoute( //<Null>
    builder: (BuildContext context) {
      return new DetailPage();
    }
  ));
}
class DetailPage extends StatefulWidget {
  const DetailPage({
    Key key,
  }) : super(key: key);
  @override
  DetailPageState createState() => new DetailPageState();
}
class DetailPageState extends State<DetailPage> {
  BuildContext _scaffoldContext;
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
           
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _scaffoldContext = context;
          return Text('123');
        }
      )          
    );
  }
}
