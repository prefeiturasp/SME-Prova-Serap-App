import 'dart:io';

import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var kDeviceType = EnumTipoDispositivo.tablet;

var kIsMobile = kDeviceType == EnumTipoDispositivo.mobile;
var kIsTablet = kDeviceType == EnumTipoDispositivo.tablet;

class TelaAdaptativaUtil {
  setup() {
    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    if (kIsWeb) {
      kDeviceType = EnumTipoDispositivo.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      kDeviceType = tela.size.shortestSide < 600 ? EnumTipoDispositivo.mobile : EnumTipoDispositivo.tablet;
    }
  }
}
