import 'package:scoped_model/scoped_model.dart';
import '../note.dart';
import '../http_service.dart';
class IndexModel extends Model {
  List _notes = [];
  List get notes => _notes;
  bool _isPerformingRequest = false;
  bool get isPerformingRequest => _isPerformingRequest;
  void onScrollBottom() {    
    _getMoreData(1);
    print('onScrollBottom...');
    notifyListeners();
  }
  void _getMoreData(int startIdx) async {
    if (!_isPerformingRequest) {
      _isPerformingRequest = true;
      List<Note> notes = await getNotes(startIdx,10);//(_notes.length, _notes.length + 10);
      _notes.addAll(notes);
      _isPerformingRequest = false;
    }
  }
}
