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
  return jsonEncode({'REV_Bible': verses.map((v) => v.toJson()).toList()});
}

WordMap _getWords(List<Verse> verses) {
  return Words.fromVerses(verses);
}

class BiblePath {
  final String book;
  final int chapter;
  final int verse;

  const BiblePath(this.book, [this.chapter = 0, this.verse = 0]);

  @override
  String toString() => chapter == 0
      ? book
      : verse == 0
          ? '$book $chapter'
          : '$book $chapter:$verse';
}

WordMap _words = {};

class Bible {
  final List<Verse> _data;
  List<Verse> get data => _data;

  const Bible(this._data);

  static Future<Bible> load() async {
    if (kIsWeb) {
      try {
        IdbFile file = const IdbFile(_fileName);
        if (await file.exists()) {
          String contents = await file.readAsString();
          var verses = _parseVerses(contents);
          return Bible(verses);
        } else {
          return await Bible._fetch();
        }
      } catch (err) {
        throw Exception("Error loading bible! $err");
      }
    } else {
      // File file = File(_fileName);
      File file = await localFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseVerses(contents);
        return Bible(verses);
      } else {
        return await Bible._fetch();
      }
    }
  }

  static Future<Bible> _fetch() async {
    var response = await http.get(Uri.parse(_url));
    var bible = Bible(await compute(_parseVerses, response.body));
    await bible.save();
    return bible;
  }

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
