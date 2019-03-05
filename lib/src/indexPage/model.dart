import 'package:scoped_model/scoped_model.dart';
import '../note.dart';
import '../http_service.dart';
import 'dart:async';
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}

class IndexModel extends Model {
  List _notes = [];
  List get notes => _notes;
  bool _isPerformingRequest = false;
  bool _isStar = false;
  bool _isReverse = false;
  bool get isReverse => _isReverse;
  bool get isStar => _isStar;
  bool get isPerformingRequest => _isPerformingRequest;
  //username 还没写完
  String _username;
  String get username => username;
  List _keywords = [];
  List get keywords => _keywords;
  void changeUsername(){

  }
  void switchReverseList(){
    _isReverse = true;
    _isStar = false;
    refreshData();
  }
  void switchAllList(){
    _isReverse = false;
    _isStar = false;
    refreshData();
  }
  void switchStarList(){
    _isStar = true;
    _isReverse = false;
    refreshData();
  }
  void toggleStar(int index){
    _notes[index].starred = !_notes[index].starred; 
    notifyListeners();
  }
  void deleteNote(int index)  { //async
    _notes.removeAt(index);
    notifyListeners();
  }
  void refreshData() async {
    if (!_isPerformingRequest) {
      _notes = [];
      _isPerformingRequest = true;
      notifyListeners();
      List<Note> notes = await getNotes(0,isStar:_isStar,isReverse:_isReverse);
      _notes = notes;
      notifyListeners();
      // await sleep(2000); // 故意停止2秒吗 脑子秀逗了
      _isPerformingRequest = false;
      notifyListeners();
      print('onScrollBottom...');
    }
  }
  void fetchKeywords() async {
    _keywords = await getKeywords();
    notifyListeners();
  }
  void getMoreData({int startIdx}) async {
    if (!_isPerformingRequest) {
      _isPerformingRequest = true;
      notifyListeners();
      List<Note> notes = await getNotes(startIdx,isStar:_isStar,isReverse:_isReverse);
      _notes.addAll(notes);
      _isPerformingRequest = false;
      notifyListeners();
      print('onScrollBottom...');
    }
  }
}
