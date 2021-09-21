import 'package:logging/logging.dart';

abstract class Loggable<T> {
  var log = Logger(T.toString());
  var shout = Logger(T.toString()).shout;
  var severe = Logger(T.toString()).severe;
  var warning = Logger(T.toString()).warning;
  var info = Logger(T.toString()).info;
  var config = Logger(T.toString()).config;
  var fine = Logger(T.toString()).fine;
  var finer = Logger(T.toString()).finer;
  var finest = Logger(T.toString()).finest;
}
