import 'dart:isolate';
import 'dart:ui';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/job.store.dart';

String kIsolateBackground = 'background_service_port';

class AppIsolates {
  static ReceivePort backgroundPort = ReceivePort();

  setup() async {
    IsolateNameServer.registerPortWithName(backgroundPort.sendPort, kIsolateBackground);

    registerUpdates();
  }

  registerUpdates() {
    backgroundPort.listen((message) {
      StatusJob jobStatus = message;

      ServiceLocator.get<JobStore>().statusJob[jobStatus.job] = jobStatus.status;
    });
  }
}
