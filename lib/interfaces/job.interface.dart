import 'job_config.interface.dart';

abstract class Job {
  JobConfig configuration() {
    return JobConfig();
  }

  Future<void> run();
}
