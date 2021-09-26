import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=201';

enum Style {
  // style: 1    This is flowing text, or prose. See most verses in the NT.
  prose,
  // style: 2    This is poetry. See Psalms, Proverbs.
  poetry,
  // style: 3    This is poetry with no small vertical space at the end of the verse. See Ezra 2
  poetryNoPostGap,
  // style: 4    This is poetry with an extra linebreak before the verse. See Judges 5:6.
  poetryPreGap,
  // style: 5    This is poetry with an extra linebreak before the verse and no vertical space after the verse. See Ezra 2:36.
  poetryPreGapNoPostGap,
  // style: 6    This is list style. It's similar to poetry... I can explain later if you want to go there.
  list,
  // style: 7    This is list style with no small vertical space at the end of the verse.
  listNoPostGap,
  // style: 8    This is list style with an extra linebreak before the verse.
  listPreGap,
  // style: 9    This is list style with an extra linebreak before the verse and no vertical space after the verse.
  listPreGapNoPostGap,
}

class Verse {
  late String book;
  late int chapter;
  late int verse;
  late String? heading;
  late bool microheading;
  late bool paragraph;
  late Style style;
  late String? footnotes;
  late String versetext;
  Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    this.heading,
    this.footnotes,
    required this.microheading,
    required this.paragraph,
    required this.style,
    required this.versetext,
  });

  Verse.fromJson(Map<String, dynamic> json)
      : book = json['book'],
        chapter = json['chapter'],
        verse = json['verse'],
        heading = json['heading'],
        footnotes = json['footnotes'],
        microheading = json['microheading'] == 1,
        paragraph = json['paragraph'] == 1,
        versetext = json['versetext'] {
    int styleInt = json['style'];
    switch (styleInt) {
      case 2:
        style = Style.poetry;
        break;
      case 3:
        style = Style.poetryNoPostGap;
        break;
      case 4:
        style = Style.poetryPreGap;
        break;
      case 5:
        style = Style.poetryPreGapNoPostGap;
        break;
      case 6:
        style = Style.list;
        break;
      case 7:
        style = Style.listNoPostGap;
        break;
      case 8:
        style = Style.listPreGap;
        break;
      case 9:
        style = Style.listPreGapNoPostGap;
        break;
      case 1:
      default:
        style = Style.prose;
        break;
    }
  }
}

List<Verse> parseVerses(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return parsed['REV_Bible']
      .map<Verse>((json) => Verse.fromJson(json))
      .toList();
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

class Bible {
  final List<Verse> _data;
  List<Verse> get data => _data;

  const Bible(this._data);

  static Future<Bible> fetch() async {
    var response = await http.get(Uri.parse(_url));
    return Bible(await compute(parseVerses, response.body));
  }

  List<String> get listBooks => _data.map((v) => v.book).toSet().toList();

  List<int> listChapters({required String book}) =>
      _data.where((v) => v.book == book).map((v) => v.chapter).toList();

  List<int> listVerses({required String book, required int chapter}) => _data
      .where((v) => v.book == book && v.chapter == chapter)
      .map((v) => v.verse)
      .toList();

  String getVerseText(
          {required String book, required int chapter, required int verse}) =>
      _data
          .firstWhere(
              (v) => v.book == book && v.chapter == chapter && v.verse == verse)
          .versetext;
}
