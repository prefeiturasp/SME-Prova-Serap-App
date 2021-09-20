import 'package:flutter/cupertino.dart';

import 'error.dto.dart';

class ResponseDTO {
  List<ErrorDTO> errors = [];
  bool success = false;
  dynamic content = "";

  ResponseDTO({
    required this.errors,
    required this.success,
    required this.content,
  });
}
