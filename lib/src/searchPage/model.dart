import 'package:scoped_model/scoped_model.dart';
import '../note.dart';
import '../http_service.dart';
class DetailModel extends Model {
  List _notes = [];
  List get notes => _notes;
  bool _isPerformingRequest = false;
  bool get isPerformingRequest => _isPerformingRequest;
}
Future<List> getSimilarList(String noteId) async {    
    return await getSimilar(noteId);
    // List _notes = [];
    // print('get similar request...');
    // List<Note> notes = await getSimilar(noteId);//(_notes.length, _notes.length + 10);
    // _notes.addAll(notes);
    // return _notes;
    // notifyListeners();
}
