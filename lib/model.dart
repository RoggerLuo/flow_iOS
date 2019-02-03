import 'package:scoped_model/scoped_model.dart';
import 'package:english_words/english_words.dart';

class MainModel extends Model {
  var _counter = 0;
  List _suggestions = <WordPair>[];
  Set _saved = new Set<WordPair>();

  int get counter => _counter;
  List get suggestions => _suggestions;

  void increment() {
    // First, increment the counter
    _counter++;
    _suggestions.addAll(generateWordPairs().take(10));

    // Then notify all the listeners.
    notifyListeners();
  }
}
