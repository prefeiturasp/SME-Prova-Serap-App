// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';
import 'package:drift/internal/migrations.dart';
import 'schema_v15.dart' as v15;
import 'schema_v19.dart' as v19;
import 'schema_v20.dart' as v20;
import 'schema_v22.dart' as v22;
import 'schema_v23.dart' as v23;
import 'schema_v24.dart' as v24;
import 'schema_v25.dart' as v25;
import 'schema_v27.dart' as v27;

class GeneratedHelper implements SchemaInstantiationHelper {
  @override
  GeneratedDatabase databaseForVersion(QueryExecutor db, int version) {
    switch (version) {
      case 15:
        return v15.DatabaseAtV15(db);
      case 19:
        return v19.DatabaseAtV19(db);
      case 20:
        return v20.DatabaseAtV20(db);
      case 22:
        return v22.DatabaseAtV22(db);
      case 23:
        return v23.DatabaseAtV23(db);
      case 24:
        return v24.DatabaseAtV24(db);
      case 25:
        return v25.DatabaseAtV25(db);
      case 27:
        return v27.DatabaseAtV27(db);
      default:
        throw MissingSchemaException(
            version, const {15, 19, 20, 22, 23, 24, 25, 27});
    }
  }
}
