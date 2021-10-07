import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rev_flutter/src/models/bible.dart';

part 'appendices.g.dart';

const _fileName = 'appendices';

const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=203';

@HiveType(typeId: 1)
class _Appendix extends VerseLike {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String appendix;

  _Appendix({
    required this.title,
    required this.appendix,
  });

  _Appendix.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        appendix = json['appendix'];

  Map<String, dynamic> get json => {
        'title': title,
        'appendix': appendix,
      };

  @override
  String get book => title;

  @override
  int get chapter => 0;

  @override
  int get verse => 0;
}

@HiveType(typeId: 2)
class Appendices extends BibleLike {
  static Appendices? _instance;

  @HiveField(0)
  final List<_Appendix> _data;

  List<_Appendix> get data => _data;

  Appendices(this._data);

  static Future<Appendices> get load async => _instance ??= await _load;

  static Future<Appendices> get _load async {
    if (_instance != null) return _instance!;
    var box = await Hive.openBox<Appendices>(_fileName);
    try {
      return box.get(0) ?? await _fetch;
    } on IndexError {
      return await _fetch;
    }
  }

  static Future<Appendices> get _fetch async {
    if (_instance != null) return _instance!;
    var response = await http.get(Uri.parse(_url));
    var verses = await compute(_parseAppendix, response.body);
    var bible = _instance = Appendices(verses);
    await bible.save();
    return bible;
  }

  static Future<Appendices> get reload => Appendices._fetch;

  @override
  Future save() async {
    var box = await Hive.openBox<Appendices>(_fileName);
    return await box.put(0, this);
  }

  String get encoded => _encodeAppendix(_data);

  String getAppendix(String title) =>
      _data.firstWhere((a) => a.title == title).appendix;

  @override
  List<String> get listBooks => _data.map((a) => a.title).toList();

  @override
  List<int> listChapters(BiblePath path) => [];

  @override
  List<int> listVerses(BiblePath path) => [];

  @override
  List<VerseLike> selectVerses(BiblePath path) => [];
}

String _encodeAppendix(List<_Appendix> data) {
  return jsonEncode({'REV_Appendices': data.map((v) => v.json).toList()});
}

List<_Appendix> _parseAppendix(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return parsed['REV_Appendices']
      .map<_Appendix>((json) => _Appendix.fromJson(json))
      .toList();
}
