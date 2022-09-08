import 'package:drift/drift.dart';

DatabaseConnection connect([String dbName = '', bool external = false]) {
  throw UnsupportedError('No suitable database implementation was found on this platform.');
}
