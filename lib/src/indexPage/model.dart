import 'package:scoped_model/scoped_model.dart';
import '../note.dart';
import '../http_service.dart';
class IndexModel extends Model {
  List _notes = [];
  List get notes => _notes;
  bool _isPerformingRequest = false;
  bool get isPerformingRequest => _isPerformingRequest;
  // void onScrollBottom() async {    
  //   await _getMoreData(1);
  //   notifyListeners();
  // }
  Future sleep(int _milliseconds) {
    return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
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
      List<Note> notes = await getNotes(0);//(_notes.length, _notes.length + 10);
      _notes = notes;
      // _isPerformingRequest = false;
      notifyListeners();
      await sleep(2000);
      _isPerformingRequest = false;
      notifyListeners();
      print('onScrollBottom...');
    }
  }
  void getMoreData({int startIdx}) async {
    if (!_isPerformingRequest) {
      _isPerformingRequest = true;
      notifyListeners();
      List<Note> notes = await getNotes(startIdx);//(_notes.length, _notes.length + 10);
      _notes.addAll(notes);
      _isPerformingRequest = false;
      notifyListeners();
      print('onScrollBottom...');
    }
  }
  void markNote(){
    
  }
}
