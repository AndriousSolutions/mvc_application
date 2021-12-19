///
import '../../view.dart';

import 'package:english_words/english_words.dart';

String _location = '========================== wordpairs_model.dart';

Future<void> wordPairsModelTest(WidgetTester tester) async {
  //ignore: avoid_print
  print('====================== Unit Testing WordPairsModel ');
  final model = WordPairsModel();
  final data = model.data;
  expect(data, isInstanceOf<String>(), reason: _location);
  //ignore: avoid_print
  print('data: $data $_location');
  final wordPair = model.current;
  expect(wordPair, isInstanceOf<WordPair>(), reason: _location);
  //ignore: avoid_print
  print('wordPair.asString: ${wordPair.asString} $_location');
  final suggestions = model.suggestions;
  expect(suggestions, isInstanceOf<List<WordPair>>(), reason: _location);
}
