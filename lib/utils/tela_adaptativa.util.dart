import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TipoDispositivo { mobile, tablet, web }

class TelaAdaptativaUtil {
  TipoDispositivo dispositivo = TipoDispositivo.tablet;

  TelaAdaptativaUtil() {
    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

    if (kIsWeb) {
      dispositivo = TipoDispositivo.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      dispositivo = tela.size.shortestSide < 600 ? TipoDispositivo.mobile : TipoDispositivo.tablet;
    }
  }
}
