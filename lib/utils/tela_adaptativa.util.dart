import 'dart:io';

import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TelaAdaptativaUtil {
  EnumTipoDispositivo dispositivo = EnumTipoDispositivo.tablet;

  TelaAdaptativaUtil() {
    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

    if (kIsWeb) {
      dispositivo = EnumTipoDispositivo.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      dispositivo = tela.size.shortestSide < 600 ? EnumTipoDispositivo.mobile : EnumTipoDispositivo.tablet;
    }
  }
}
