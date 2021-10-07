import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rev_flutter/src/models/exceptions.dart';

import 'bible.dart';
import 'words.dart';

part 'commentary.g.dart';

const _fileName = 'commentary';
const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=202';

WordMap _words = {};

WordMap _getWords(List<Comment> verses) {
  return verses.words;
}

@HiveType(typeId: 4)
class Comment extends VerseLike {
  @HiveField(0)
  @override
  late final String book;
  @HiveField(1)
  @override
  late final int chapter;
  @HiveField(2)
  @override
  late final int verse;
  @HiveField(3)
  late final String commentary;

  Comment(
    this.book,
    this.chapter,
    this.verse,
    this.commentary,
  );

  Comment.fromJson(Map<String, dynamic> json) {
    book = json['book'];
    var c = json['chapter'];
    if (c.runtimeType == String) {
      chapter = int.parse(c);
    } else {
      chapter = c;
    }
    var v = json['verse'];
    if (v.runtimeType == String) {
      verse = int.parse(v);
    } else {
      verse = v;
    }
    commentary = json['commentary'];
  }

  Map<String, dynamic> get json => {
        'book': book,
        'chapter': chapter,
        'verse': verse,
        'commentary': commentary,
      };
}

@HiveType(typeId: 5)
class Commentary extends BibleLike {
  static Commentary? _instance;

  @HiveField(0)
  final List<Comment> _data;

  List<Comment> get data => _data;

  Commentary(this._data);

  bool contains(BiblePath path) {
    return _data
        .where((element) =>
            element.book == path.book &&
            element.chapter == path.chapter &&
            element.verse == path.verse)
        .isNotEmpty;
  }

  static Future<Commentary> get load async => _instance ??= await _load;

  static Future<Commentary> get _load async {
    if (_instance != null) return _instance!;
    var box = await Hive.openBox<Commentary>(_fileName);
    try {
      return box.get(0) ?? await Commentary._fetch;
    } on IndexError {
      return await Commentary._fetch;
    }
  }

  static Future<Commentary> get _fetch async {
    if (_instance != null) return _instance!;
    try {
      var response = await http.get(Uri.parse(_url));
      var verses = await compute(_parseComments, response.body);
      _instance = Commentary(verses);
      await _instance!.save();
      return _instance!;
    } on Exception catch (err) {
      throw FetchFileError(err);
    }
  }

  static Future<Commentary> get reload async =>
      _instance = await Commentary._fetch;

  @override
  Future save() async {
    var box = await Hive.openBox<Commentary>(_fileName);
    await box.put(0, this);
  }

  String get encoded => _encodeComments(_data);

  @override
  List<String> get listBooks => _data.map((v) => v.book).toSet().toList();

  @override
  List<Comment> selectVerses(BiblePath path) {
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

  @override
  List<int> listChapters(BiblePath path) => _data
      .where((v) => v.book == path.book)
      .map((v) => v.chapter)
      .toSet()
      .toList();

  @override
  List<int> listVerses(BiblePath path) => _data
      .where((v) => v.book == path.book && v.chapter == path.chapter)
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

  String getCommentary(BiblePath path) => _data
      .firstWhere((v) =>
          v.book == path.book &&
          v.chapter == path.chapter &&
          v.verse == path.verse)
      .commentary;
}

List<Comment> _parseComments(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return parsed['REV_Commentary']
      .map<Comment>((json) => Comment.fromJson(json))
      .toList();
}

String _encodeComments(List<Comment> data) {
  return jsonEncode({'REV_Commentary': data.map((v) => v.json).toList()});
}
