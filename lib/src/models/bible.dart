import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rev_flutter/src/models/words.dart';

import 'idb_file.dart';
import 'verse.dart';

const _fileName = 'bible';

const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=201';

List<Verse> _parseVerses(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return parsed['REV_Bible']
      .map<Verse>((json) => Verse.fromJson(json))
      .toList();
}

String _encodeVerses(List<Verse> verses) {
  return jsonEncode({'REV_Bible': verses.map((v) => v.json).toList()});
}

WordMap _getWords(List<Verse> verses) {
  return verses.words;
}

class BiblePath {
  final String book;
  final int? chapter;
  final int? verse;

  const BiblePath(this.book, [this.chapter, this.verse]);

  @override
  String toString() => chapter == null
      ? book
      : verse == null
          ? '$book $chapter'
          : '$book $chapter:$verse';
}

WordMap _words = {};

class Bible {
  final List<Verse> _data;
  List<Verse> get data => _data;

  const Bible(this._data);

  static Future<Bible> get load async {
    if (kIsWeb) {
      try {
        IdbFile file = const IdbFile(_fileName);
        if (await file.exists()) {
          String contents = await file.readAsString();
          var verses = _parseVerses(contents);
          return Bible(verses);
        } else {
          return await Bible._fetch;
        }
      } catch (err) {
        throw Exception("Error loading bible! $err");
      }
    } else {
      File file = await localFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseVerses(contents);
        return Bible(verses);
      } else {
        return await Bible._fetch;
      }
    }
  }

  static Future<Bible> get _fetch async {
    var response = await http.get(Uri.parse(_url));
    var bible = Bible(await compute(_parseVerses, response.body));
    await bible.save();
    return bible;
  }

  static Future<Bible> get reload => Bible._fetch;

  Future save() async {
    if (kIsWeb) {
      IdbFile idbFile = const IdbFile(_fileName);
      await idbFile.writeAsString(encoded);
    } else {
      File file = await localFile(_fileName);
      await file.writeAsString(encoded);
    }
  }

  String get encoded => _encodeVerses(_data);

  List<String> get listBooks => _data.map((v) => v.book).toSet().toList();

  List<Verse> selectVerses(BiblePath path) {
    if (path.verse != null && path.chapter != null) {
      return _data
          .where((v) =>
              v.book == path.book &&
              v.chapter == path.chapter &&
              v.verse == path.verse)
          .toList();
    }
    if (path.chapter != null) {
      return _data
          .where((v) => v.book == path.book && v.chapter == path.chapter)
          .toList();
    }
    return _data.where((v) => v.book == path.book).toList();
  }

  String getChapter(
    BiblePath path, {
    ViewMode viewMode = ViewMode.paragraph,
    bool linkCommentary = true,
  }) {
    if (path.chapter == null) throw Exception('Chapter Not Selected!');
    var spanDepth = 0;
    final verses = selectVerses(path);
    var result = '';
    for (var i = 0; i < verses.length; i++) {
      var v = verses[i];
      var verse = v.raw(viewMode: viewMode, linkCommentary: linkCommentary);
      String preverse = '', midverse = '', endverse = '';
      // This is a flag for adding the heading to the top.
      bool addHeading = false;

      // Get the previous verse
      final pv = verses[i > 0 ? i - 1 : i];
      // check for a style change
      var styleChange = pv.style == v.style ||
          verse.contains(RegExp(
              r'(\[hpbegin\])|(\[hpend\])|(\[listbegin\])|(\[listend\])'));
      // if there is no [mvh] tag but there is a heading - note we need to add
      // the heading to the top.
      if (!verse.contains('[mvh]')) {
        addHeading = true;
      } else {
        verse = verse.replaceFirst('[mvh]', v.styledHeading);
      }

      switch (viewMode) {
        case ViewMode.verseBreak:
          verse = _stripStyle(verse);
          result += '''
          ${addHeading ? v.styledHeading : ''}
          <div class="versebreak">
          $verse
          </div>
          ''';
          break;
        case ViewMode.paragraph:
        case ViewMode.reading:
        default:
          if (styleChange || spanDepth == 0 || v.paragraph) {
            if (!verse.contains(RegExp(
                r'(\[hpbegin\])|(\[hpend\])|(\[listbegin\])|(\[listend\])'))) {
              if (spanDepth > 0) {
                preverse += '</span>';
                spanDepth -= 1;
              }
              preverse += '<span class="${v.style.className}">';
              spanDepth += 1;
            } else if (verse
                .contains(RegExp(r'(\[hpbegin\])|(\[listbegin\])'))) {
              if (spanDepth > 0) {
                preverse += '</span><span class="prose">';
                midverse += '</span>';
                spanDepth -= 1;
              }
              midverse += '<span class="${v.style.className}">';
              spanDepth += 1;
            } else {
              if (spanDepth > 0) {
                midverse += '</span>';
                spanDepth -= 1;
              }
              midverse += '<span class="prose">';
              endverse += '</span>';
            }
          }
          verse = verse.replaceAll('[hpbegin]', midverse);
          verse = verse.replaceAll('[hpend]', midverse);
          verse = verse.replaceAll('[listbegin]', midverse);
          verse = verse.replaceAll('[listend]', midverse);

          verse = verse.replaceAll('[hp]', '<br />');
          verse = verse.replaceAll('[li]', '<br />');
          verse = verse.replaceAll('[lb]', '<br />');
          verse = verse.replaceAll('[br]', '<br />');

          verse = verse.replaceAll('[fn]', '<fn></fn>');
          verse = verse.replaceAll('[pg]', '<p></p>');

          verse = verse.replaceAll('[bq/]', '<span class="bq">');
          verse = verse.replaceAll('[/bq]', '</span>');
          verse = _stripStyle(verse);

          result += '''
          $preverse
          ${addHeading ? v.styledHeading : ''}
          $verse
          $endverse
          ${v.isPoetry ? '<br/>' : ''}
          ''';
      }
    }
    return result;
  }

  BiblePath nextChapter(BiblePath path) {
    if (path.chapter == null) return BiblePath(path.book, 1);
    final chapters = listChapters(book: path.book);
    if (chapters.contains(path.chapter! + 1)) {
      return BiblePath(path.book, path.chapter! + 1);
    } else {
      final books = listBooks;
      final index = books.indexOf(path.book);
      if (books.length > index + 1) {
        return BiblePath(
          books[index + 1],
          1, // chapter
        );
      } else {
        return path;
      }
    }
  }

  BiblePath prevChapter(BiblePath path) {
    if (path.chapter == null) return BiblePath(path.book, 1);
    final chapters = listChapters(book: path.book);
    if (chapters.contains(path.chapter! - 1)) {
      return BiblePath(path.book, path.chapter! - 1);
    } else {
      final books = listBooks;
      final index = books.indexOf(path.book);
      if (index - 1 >= 0) {
        final chapters = listChapters(book: books[index - 1]);
        return BiblePath(
          books[index - 1],
          chapters[chapters.length - 1], // chapter
        );
      } else {
        return path;
      }
    }
  }

  String _stripStyle(String verse) {
    verse = verse.replaceAll('[hpbegin]', ' ');
    verse = verse.replaceAll('[hpend]', ' ');
    verse = verse.replaceAll('[hp]', ' ');

    verse = verse.replaceAll('[listbegin]', ' ');
    verse = verse.replaceAll('[listend]', ' ');
    verse = verse.replaceAll('[li]', ' ');

    verse = verse.replaceAll('[lb]', ' ');
    verse = verse.replaceAll('[br]', ' ');
    verse = verse.replaceAll('[fn]', ' ');
    verse = verse.replaceAll('[pg]', ' ');
    verse = verse.replaceAll('[bq]', ' ');
    verse = verse.replaceAll('[/bq]', ' ');

    // FINALLY replace the brackets for questionable text.
    verse = verse.replaceAll('[[', '<em class="questionable">');
    verse = verse.replaceAll(']]', '</em>');
    verse = verse.replaceAll('[', '<em>');
    verse = verse.replaceAll(']', '</em>');

    return verse;
  }

  List<int> listChapters({required String book}) =>
      _data.where((v) => v.book == book).map((v) => v.chapter).toSet().toList();

  List<int> listVerses({required String book, required int chapter}) => _data
      .where((v) => v.book == book && v.chapter == chapter)
      .map((v) => v.verse)
      .toList();

  Future get words async {
    if (_words == {}) {
      _words = await compute(_getWords, _data);
    }
    return _words;
  }

  Future<WordMap> listWords({
    String? book,
    int? chapter,
    int? verse,
  }) async {
    WordMap words = await this.words;
    WordMap shortList = {};
    words.forEach((word, pathSet) {
      if (pathSet.any((path) =>
          book == null ||
          path.book == book && chapter == null ||
          path.book == book && path.chapter == chapter && verse == null ||
          path.book == book &&
              path.chapter == chapter &&
              path.verse == verse)) {
        if (shortList.containsKey(word)) {
          shortList[word]?.addAll(pathSet);
        } else {
          shortList[word] = pathSet;
        }
      }
    });
    return shortList;
  }

  String getVerseText(
          {required String book, required int chapter, required int verse}) =>
      _data
          .firstWhere(
              (v) => v.book == book && v.chapter == chapter && v.verse == verse)
          .versetext;
}
