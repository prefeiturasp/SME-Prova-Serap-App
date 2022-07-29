// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:appserap/utils/idb_file.util.dart';

String buildUrl(Uint8List file) {
  final blob = Blob([file]);
  return Url.createObjectUrlFromBlob(blob);
}

saveFile(String path, Uint8List bodyBytes) async {
  var idbFileVideo = IdbFile(path);
  await idbFileVideo.writeAsBytes(bodyBytes);
}

Future<bool> fileExists(String path) async {
  var idbFile = IdbFile(path);
  return await idbFile.exists();
}

apagarArquivo(String path) async {
  await IdbFile(path).delete();
}

Future<String?> buildPath(String? path) async {
  return path;
}
