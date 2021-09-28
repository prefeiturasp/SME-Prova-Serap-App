import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:background_fetch/background_fetch.dart';

class SincronizarRespostas with Worker {
  SincronizarRespostas() {
    configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 1,
        stopOnTerminate: false,
        startOnBoot: true,
        requiredNetworkType: NetworkType.ANY,
      ),
    );
  }

  @override
  onFetch(String taskId) async {
    // <-- Event callback
    // This callback is typically fired every 15 minutes while in the background.
    print('[BackgroundFetch] Event received.');
    // IMPORTANT:  You must signal completion of your fetch task or the OS could
    // punish your app for spending much time in the background.
  }

  @override
  onTimeOut(String taskId) async {
    // <-- Task timeout callback
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    BackgroundFetch.finish(taskId);
  }
}
