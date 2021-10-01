import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rev_flutter/src/models/bible.dart';

import 'idb_file.dart';

const _fileName = 'appendices';

const _url = 'https://www.revisedenglishversion.com/jsondload.php?fil=203';

class _Appendix implements VerseLike {
  final String title;
  final String appendix;

  const _Appendix({
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
  final List<_Appendix> _data;
  List<_Appendix> get data => _data;

  const Appendices(this._data);

  static Future<Appendices> get load async {
    if (kIsWeb) {
      try {
        IdbFile file = const IdbFile(_fileName);
        if (await file.exists()) {
          String contents = await file.readAsString();
          var verses = _parseAppendix(contents);
          return Appendices(verses);
        } else {
          return await Appendices._fetch;
        }
      } catch (err) {
        throw Exception("Error loading appendix! $err");
      }
    } else {
      File file = await localFile(_fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var verses = _parseAppendix(contents);
        return Appendices(verses);
      } else {
        return await Appendices._fetch;
      }
    }
  }

  static Future<Appendices> get _fetch async {
    var response = await http.get(Uri.parse(_url));
    var bible = Appendices(await compute(_parseAppendix, response.body));
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
