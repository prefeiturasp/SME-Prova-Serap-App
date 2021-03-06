// GENERATED CODE, DO NOT EDIT BY HAND.
//@dart=2.12
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations.dart';
import 'schema_v15.dart' as v15;
import 'schema_v19.dart' as v19;

class GeneratedHelper implements SchemaInstantiationHelper {
  @override
  GeneratedDatabase databaseForVersion(QueryExecutor db, int version) {
    switch (version) {
      case 15:
        return v15.DatabaseAtV15(db);
      case 19:
        return v19.DatabaseAtV19(db);
      default:
        throw MissingSchemaException(version, const {15, 19});
    }
  }
}
