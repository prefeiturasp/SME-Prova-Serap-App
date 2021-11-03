import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TipoDispositivo { mobile, tablet, web }

class TelaAdaptativaUtil {
  TipoDispositivo dispositivo = TipoDispositivo.tablet;

  TelaAdaptativaUtil(){
    if (kIsWeb) {
      dispositivo = TipoDispositivo.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      if ((ScreenUtil().orientation == Orientation.portrait && ScreenUtil.defaultSize.width < 600) ||
          (ScreenUtil().orientation == Orientation.landscape && ScreenUtil.defaultSize.height < 600)) {
        dispositivo = TipoDispositivo.mobile;
      } else {
        dispositivo = TipoDispositivo.tablet;
      }
    } 
  }


}
