import 'dart:io';

import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var kDeviceType = EnumTipoDispositivo.TABLET;

var kIsMobile = kDeviceType == EnumTipoDispositivo.MOBILE;
var kIsTablet = kDeviceType == EnumTipoDispositivo.TABLET;

class TelaAdaptativaUtil {
  setup() {
    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    if (kIsWeb) {
      kDeviceType = EnumTipoDispositivo.WEB;
    } else if (Platform.isAndroid || Platform.isIOS) {
      kDeviceType = tela.size.shortestSide < 600 ? EnumTipoDispositivo.MOBILE : EnumTipoDispositivo.TABLET;
    }
  }
}
