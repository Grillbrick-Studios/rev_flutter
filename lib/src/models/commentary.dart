import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'bible.dart';
import 'idb_file.dart';
import 'words.dart';

const _fileName = 'commentary';
const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=202';

WordMap _words = {};

WordMap _getWords(List<Comment> verses) {
  return verses.words;
}

class Comment implements VerseLike {
  @override
  late final String book;
  @override
  late final int chapter;
  @override
  late final int verse;
  late final String commentary;

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

class Commentary extends BibleLike {
  static List<Comment> _data = [];
  List<Comment> get data => _data;

  Commentary() {
    if (Commentary._data.isEmpty) Commentary.load;
  }

  static Future<Commentary> get load async {
    if (Commentary._data.isNotEmpty) return Commentary();
    if (kIsWeb) {
      try {
        IdbFile file = const IdbFile(_fileName);
        if (await file.exists()) {
          String contents = await file.readAsString();
          var verses = _parseComments(contents);
          Commentary._data = verses;
          return Commentary();
        } else {
          return await Commentary._fetch;
        }
      } catch (err) {
        throw Exception("Error loading commentary! $err");
      }
    } else {
      File file = await localFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseComments(contents);
        Commentary._data = verses;
        return Commentary();
      } else {
        return await Commentary._fetch;
      }
    }
  }

  static Future<Commentary> get _fetch async {
    var response = await http.get(Uri.parse(_url));
    Commentary._data = await compute(_parseComments, response.body);
    var commentary = Commentary();
    await commentary.save();
    return commentary;
  }

  static Future<Commentary> get reload => Commentary._fetch;

  Future save() async {
    if (kIsWeb) {
      IdbFile idbFile = const IdbFile(_fileName);
      await idbFile.writeAsString(encoded);
    } else {
      File file = await localFile(_fileName);
      await file.writeAsString(encoded);
    }
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

  String getCommentary(
          {required String book, required int chapter, required int verse}) =>
      _data
          .firstWhere(
              (v) => v.book == book && v.chapter == chapter && v.verse == verse)
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
