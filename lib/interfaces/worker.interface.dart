import 'package:background_fetch/background_fetch.dart';

abstract class Worker {
  late int status;

  configure(BackgroundFetchConfig config) async {
    status = await BackgroundFetch.configure(
      config,
      onFetch,
      onTimeOut,
    );
  }

  onFetch(String taskId);
  onTimeOut(String taskId) async {
    BackgroundFetch.finish(taskId);
  }
}
