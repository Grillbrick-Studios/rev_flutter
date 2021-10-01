import 'bible.dart';
import 'commentary.dart';
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

  static WordMap fromComment(Comment c) {
    var path = BiblePath(c.book, c.chapter, c.verse);
    WordMap map = {};
    c.commentary
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

  static WordMap fromComments(List<Comment> v) {
    WordMap map = {};
    for (var value in v.map((e) => fromComment(e))) {
      map.addAll(value);
    }
    return map;
  }
}

extension VersesToWords on List<Verse> {
  WordMap get words => Words.fromVerses(this);
}

extension CommentsToWords on List<Comment> {
  WordMap get words => Words.fromComments(this);
}
