import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

/// Renames all .part.js files to unique name not conflicting with future updates,
/// updates the references in flutter_service_worker.js and main.dart.js,
/// and updates the main.dart.js hash in flutter_service_worker.js.
void main() {
  List<FileSystemEntity> entries = Directory('build/web').listSync();

  String flutterServiceWorkerJs = File('build/web/flutter_service_worker.js').readAsStringSync();
  String mainDartJs = File('build/web/main.dart.js').readAsStringSync();
  String indexHtml = File('build/web/index.html').readAsStringSync();

  String pubspec = File('pubspec.yaml').readAsStringSync();
  String prefix = pubspec.split('version: ')[1].split('\n')[0].replaceAll('+', '_');

  for (FileSystemEntity entry in entries) {
    String oldFileName = basename(entry.path);
    String newFileName = '${prefix}_$oldFileName';

    if (!RegExp(r'main\.dart\.js').hasMatch(oldFileName)) {
      continue;
    }

    print('Processing "$oldFileName"');

    // Replace old file names with new file names
    // in flutter_service_worker.js and main.dart.js
    flutterServiceWorkerJs = flutterServiceWorkerJs
        .replaceAll(
          '"$oldFileName"',
          '"$newFileName"',
        )
        .replaceAll(
          "'$oldFileName'",
          "'$newFileName'",
        );

    mainDartJs = mainDartJs
        .replaceAll(
          '"$oldFileName"',
          '"$newFileName"',
        )
        .replaceAll(
          "'$oldFileName'",
          "'$newFileName'",
        );

    indexHtml = indexHtml
        .replaceAll(
          '"$oldFileName"',
          '"$newFileName"',
        )
        .replaceAll(
          "'$oldFileName'",
          "'$newFileName'",
        );

    // Replace source map url in .part.js file
    String partJsContent = File('build/web/$oldFileName').readAsStringSync();
    partJsContent = partJsContent.replaceAll(
      RegExp('//# sourceMappingURL=${RegExp.escape(oldFileName)}\\.map'),
      '//# sourceMappingURL=$newFileName.map',
    );
    File('build/web/$oldFileName').writeAsStringSync(partJsContent);

    // Rename .part.js file
    File('build/web/$oldFileName').renameSync('build/web/$newFileName');

    // Update .part.js hash in flutter_service_worker.js
    flutterServiceWorkerJs = flutterServiceWorkerJs.replaceAll(
      RegExp('"${RegExp.escape(newFileName)}": *"[a-zA-Z0-9]+"'),
      '"$newFileName": "${getMd5Hash(partJsContent)}"',
    );
  }

  print('Finishing...');

  // Update main.dart.js hash in flutter_service_worker.js
  flutterServiceWorkerJs = flutterServiceWorkerJs.replaceAll(
    RegExp(r'"main\.dart\.js": *"[a-zA-Z0-9]+"'),
    '"main.dart.js": "${getMd5Hash(mainDartJs)}"',
  );

  File('build/web/flutter_service_worker.js').writeAsStringSync(flutterServiceWorkerJs);
  File('build/web/main.dart.js').writeAsStringSync(mainDartJs);
  File('build/web/index.html').writeAsStringSync(indexHtml);

  print('Done!');
}

String getMd5Hash(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
