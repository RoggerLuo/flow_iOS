import 'package:scoped_model/scoped_model.dart';
import 'package:english_words/english_words.dart';

class IndexModel extends Model {
  var _counter = 0;
  List _suggestions = <WordPair>[]; //WordPair.random(),WordPair.random()
  Set _saved = new Set<WordPair>();
  bool isPerformingRequest = false;

  int get counter => _counter;
  List get suggestions => _suggestions;

  void increment() {
    // First, increment the counter
    _counter++;
    // isPerformingRequest = true;
    _suggestions.addAll(generateWordPairs().take(10));
    print('increment.....');
    // Then notify all the listeners.
    notifyListeners();
  }
}
