import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rev_flutter/src/models/bible.dart';

import 'idb_file.dart';

const _fileName = 'appendices';

const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=203';

class _Appendix extends VerseLike {
  final String title;
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

class Appendices extends BibleLike {
  static Appendices? _instance;
  final List<_Appendix> _data;
  List<_Appendix> get data => _data;

  Appendices._(this._data);
  static Future<Appendices> get load async => _instance ??= await _load;

  static Future<Appendices> get _load async {
    if (_instance != null) return _instance!;
    if (kIsWeb) {
      IdbFile file = const IdbFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseAppendix(contents);
        return _instance = Appendices._(verses);
      } else {
        return await Appendices._fetch;
      }
    } else {
      File file = await localFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseAppendix(contents);
        return _instance = Appendices._(verses);
      } else {
        return await Appendices._fetch;
      }
    }
  }

  static Future<Appendices> get _fetch async {
    if (_instance != null) return _instance!;
    var response = await http.get(Uri.parse(_url));
    var verses = await compute(_parseAppendix, response.body);
    var bible = _instance = Appendices._(verses);
    await bible.save();
    return bible;
  }

  static Future<Appendices> get reload => Appendices._fetch;

  Future save() async {
    if (kIsWeb) {
      IdbFile idbFile = const IdbFile(_fileName);
      await idbFile.writeAsString(encoded);
    } else {
      File file = await localFile(_fileName);
      await file.writeAsString(encoded);
    }
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
