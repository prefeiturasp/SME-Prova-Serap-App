import 'dart:html' if (dart.library.io) 'dart:io';

import 'dart:typed_data';

String buildUrl(Uint8List file) {
  final blob = Blob([file]);
  return Url.createObjectUrlFromBlob(blob);
}
