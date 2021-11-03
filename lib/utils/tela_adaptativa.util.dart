import 'dart:io';

import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TelaAdaptativaUtil {
  EnumTipoDispositivo dispositivo = EnumTipoDispositivo.tablet;

  TelaAdaptativaUtil(){
    if (kIsWeb) {
      dispositivo = EnumTipoDispositivo.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      if (
        (ScreenUtil().orientation == Orientation.portrait && ScreenUtil.defaultSize.width < 600)
        ||
        (ScreenUtil().orientation == Orientation.landscape && ScreenUtil.defaultSize.height < 600)
        ) {
        dispositivo = EnumTipoDispositivo.mobile;
      } 
      else {
        dispositivo = EnumTipoDispositivo.tablet;
      }
    } 
  }
}
