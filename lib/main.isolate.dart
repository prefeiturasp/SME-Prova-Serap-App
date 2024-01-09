import 'dart:isolate';
import 'dart:ui';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/job.store.dart';
import 'package:flutter/foundation.dart';

String kIsolateBackground = 'background_service_port';

class AppIsolates {
  static ReceivePort backgroundPort = ReceivePort();

  setup() async {
    if (kIsWeb) {
      return;
    }

    IsolateNameServer.registerPortWithName(backgroundPort.sendPort, kIsolateBackground);

    registerUpdates();
  }

  registerUpdates() {
    backgroundPort.listen((message) {
      StatusJob jobStatus = message;

      sl.get<JobStore>().statusJob[jobStatus.job] = jobStatus.status;
    });
  }
}
