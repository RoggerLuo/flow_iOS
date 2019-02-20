import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';
import 'mainList.dart';
import '../editPage/index.dart';
import '../note.dart';
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}
class IndexPage extends StatefulWidget {
  @override
  createState() => IndexPageState();
}
class IndexPageState extends State<IndexPage> {
  BuildContext _bodyContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("drawer page"),
              trailing: Icon(Icons.arrow_downward),
            ),
            
          ],
        ),
      ),
      appBar: AppBar(
        title: new Text('Flow'),
        leading : IconButton(icon: Icon(Icons.list), onPressed: _openDrawer),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshNotesButton)
        ],
      ),
      body: Builder( // 使用builder是为了暴露出context
        builder: (context) {
          _bodyContext = context;
          return Container(
            color: Colors.white,
            child: buildMainList(),            
          );
        }
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.blueGrey),
        child: new FloatingActionButton(
          onPressed: () async {
            int createTime = DateTime.now().millisecondsSinceEpoch~/1000;
            int modifyTime = createTime;
            Note _note = Note(content:'',id:-1,createTime:createTime,modifyTime:modifyTime);
            String rs = await routeToNew(_bodyContext,note:_note,changeNote:(){});
            if(rs == 'success') {
              ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();
              await sleep(300);
              Scaffold.of(_bodyContext).showSnackBar(
                SnackBar(
                  content: Text("新建笔记保存成功"),
                  backgroundColor:Colors.lightGreen
                )
              );
            }
          },
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
  void _openDrawer(){
    Scaffold.of(_bodyContext).openDrawer();
  }
  void _refreshNotesButton() {
    ScopedModel.of<IndexModel>(context, rebuildOnChange: true).refreshData();
  }
}  
