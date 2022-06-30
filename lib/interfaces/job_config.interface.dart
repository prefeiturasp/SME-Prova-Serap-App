import 'package:workmanager/workmanager.dart';

class JobConfig {
  Duration frequency;
  String uniqueName;
  String taskName;
  Constraints? constraints;

  JobConfig({
    this.frequency = const Duration(days: 1),
    this.uniqueName = '',
    this.taskName = '',
    this.constraints,
  });
}
