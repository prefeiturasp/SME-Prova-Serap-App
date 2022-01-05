import 'dart:typed_data';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

///
/// A file using Indexed DB
///
class IdbFile {
  static const int _version = 1;
  static const String _dbName = 'files.db';
  static const String _objectStoreName = 'files';
  static const String _propNameFilePath = 'filePath';
  static const String _propNameFileContents = 'contents';

  IdbFile(this._filePath);

  String _filePath;

  Future<Database> _openDb() async {
    final idbFactory = getIdbFactory();
    if (idbFactory == null) {
      throw Exception('getIdbFactory() failed');
    }
    return idbFactory.open(
      _dbName,
      version: _version,
      onUpgradeNeeded: (e) => e.database.createObjectStore(_objectStoreName, keyPath: _propNameFilePath),
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

  Future<Uint8List> readAsBytes() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if (object == null) {
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as Uint8List;
  }

  Future<String> readAsString() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if (object == null) {
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as String;
  }

  Future<void> writeAsBytes(Uint8List contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put({
      _propNameFilePath: _filePath,
      _propNameFileContents: contents,
    }); // if the file exists, it will be replaced.
    await txn.completed;
  }

  Future<void> writeAsString(String contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put(
        {_propNameFilePath: _filePath, _propNameFileContents: contents}); // if the file exists, it will be replaced.
    await txn.completed;
  }

  Future<void> delete() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.delete(_filePath);
    await txn.completed;
  }
}
