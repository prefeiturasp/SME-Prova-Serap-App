import 'dart:io';

import 'dart:typed_data';

import 'package:path/path.dart';

String buildUrl(Uint8List file) {
  return File.fromRawPath(file).path;
}

saveFile(String path, Uint8List bodyBytes) async {
  await Directory(dirname(path)).create(recursive: true);
  await File(path).writeAsBytes(bodyBytes);
}

apagarArquivo(String path) async {
  await File(path).delete();
}
