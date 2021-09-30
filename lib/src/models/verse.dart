import 'words.dart';

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

int _styleToInt(Style style) {
  switch (style) {
    case Style.poetry:
      return 2;
    case Style.poetryNoPostGap:
      return 3;
    case Style.poetryPreGap:
      return 4;
    case Style.poetryPreGapNoPostGap:
      return 5;
    case Style.list:
      return 6;
    case Style.listNoPostGap:
      return 7;
    case Style.listPreGap:
      return 8;
    case Style.listPreGapNoPostGap:
      return 9;
    case Style.prose:
    default:
      return 1;
  }
}

Style _intToStyle(int style) {
  switch (style) {
    case 2:
      return Style.poetry;
    case 3:
      return Style.poetryNoPostGap;
    case 4:
      return Style.poetryPreGap;
    case 5:
      return Style.poetryPreGapNoPostGap;
    case 6:
      return Style.list;
    case 7:
      return Style.listNoPostGap;
    case 8:
      return Style.listPreGap;
    case 9:
      return Style.listPreGapNoPostGap;
    case 1:
    default:
      return Style.prose;
  }
}

class Verse {
  String book;
  int chapter;
  int verse;
  String? heading;
  bool microheading;
  bool paragraph;
  Style style;
  String? footnotes;
  String versetext;
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
        versetext = json['versetext'],
        style = _intToStyle(json['style']);

  Map<String, dynamic> toJson() => {
        'book': book,
        'chapter': chapter,
        'verse': verse,
        'heading': heading,
        'footnotes': footnotes,
        'microheading': microheading ? 1 : 0,
        'paragraph': paragraph ? 1 : 0,
        'versetext': versetext,
        'style': _styleToInt(style),
      };

  WordMap get words => Words.fromVerse(this);
}
