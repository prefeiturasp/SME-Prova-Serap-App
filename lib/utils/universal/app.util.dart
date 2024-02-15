import 'dart:io';

import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

String buildUrl(Uint8List file) {
  return File.fromRawPath(file).path;
}

saveFile(String path, Uint8List bodyBytes) async {
  String newPath = (await getApplicationDocumentsDirectory()).path + "/" + path;

  await Directory(dirname(newPath)).create(recursive: true);
  await File(newPath).writeAsBytes(bodyBytes);
}

Future<bool> fileExists(String path) async {
  return await File(path).exists();
}

apagarArquivo(String path) async {
  var file = File((await buildPath(path))!);

  if (await file.exists()) {
    await file.delete();
  }
}

Future<String?> buildPath(String? path) async {
  if (path != null) {
    return (await getApplicationDocumentsDirectory()).path + "/" + path;
  }
}

reload() {
  // none
}
