import 'dart:io';

import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rev_flutter/src/models/exceptions.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fileName) async {
  final path = await localPath;
  return File('$path/$fileName');
}

///
/// A file using Indexed DB
///
class IdbFile {
  static const int _version = 1;
  static const String _dbName = 'files.db';
  static const String _objectStoreName = 'files';
  static const String _propNameFilePath = 'filePath';
  static const String _propNameFileContents = 'contents';

  const IdbFile(this._filePath);

  final String _filePath;

  String get path => _filePath;

  Future<Database> _openDb() async {
    final idbFactory = getIdbFactory();
    if (idbFactory == null) {
      throw IdbFactoryError(Exception('getIdbFactory() returned null!'));
    }
    return idbFactory.open(
      _dbName,
      version: _version,
      onUpgradeNeeded: (e) => e.database
          .createObjectStore(_objectStoreName, keyPath: _propNameFilePath),
    );
  }

  Future<bool> exists() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath);
    await txn.completed;
    return object != null;
  }

  Future<String> readAsString() async {
    try {
      final db = await _openDb();
      final txn = db.transaction(_objectStoreName, idbModeReadOnly);
      final store = txn.objectStore(_objectStoreName);
      final object = await store.getObject(_filePath) as Map?;
      await txn.completed;
      if (object == null) {
        throw ReadFileError(Exception('file not found: $_filePath'));
      }
      return object['contents'] as String;
    } on Exception catch (err) {
      throw ReadFileError(err);
    }
  }

  Future<void> writeAsString(String contents) async {
    try {
      final db = await _openDb();
      final txn = db.transaction(_objectStoreName, idbModeReadWrite);
      final store = txn.objectStore(_objectStoreName);
      await store.put({
        _propNameFilePath: _filePath,
        _propNameFileContents: contents
      }); // if the file exists, it will be replaced.
      await txn.completed;
    } on Exception catch (err) {
      throw WriteFileError(err);
    }
  }

  Future<void> delete() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.delete(_filePath);
    await txn.completed;
  }
}
