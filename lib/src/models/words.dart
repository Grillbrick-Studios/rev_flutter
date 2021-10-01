import 'bible.dart';
import 'verse.dart';

typedef WordMap = Map<String, Set<BiblePath>>;

extension Words on WordMap {
  static WordMap fromVerse(Verse v) {
    var path = BiblePath(v.book, v.chapter, v.verse);
    WordMap map = {};
    v.versetext
        .split(RegExp(r'[^\w]'))
        // TODO: Filter out non-words etc.
        .where((e) => e.isNotEmpty)
        .forEach((e) {
      if (map.containsKey(e)) {
        map[e]?.add(path);
      } else {
        map[e] = {path};
      }
    });
    return map;
  }

  static WordMap fromVerses(List<Verse> v) {
    WordMap map = {};
    for (var value in v.map((e) => fromVerse(e))) {
      map.addAll(value);
    }
    return map;
  }
}

extension IntoWords on List<Verse> {
  WordMap get words => Words.fromVerses(this);
}
