import 'package:logging/logging.dart';

abstract class Loggable<T> {
  static Logger logName(String name) => Logger(name);

  void Function(Object?, [Object?, StackTrace?]) get shout => logName('$runtimeType').shout;
  void Function(Object?, [Object?, StackTrace?]) get severe => logName('$runtimeType').severe;
  void Function(Object?, [Object?, StackTrace?]) get warning => logName('$runtimeType').warning;
  void Function(Object?, [Object?, StackTrace?]) get info => logName('$runtimeType').info;
  void Function(Object?, [Object?, StackTrace?]) get config => logName('$runtimeType').config;
  void Function(Object?, [Object?, StackTrace?]) get fine => logName('$runtimeType').fine;
  void Function(Object?, [Object?, StackTrace?]) get finer => logName('$runtimeType').finer;
  void Function(Object?, [Object?, StackTrace?]) get finest => logName('$runtimeType').finest;
}
