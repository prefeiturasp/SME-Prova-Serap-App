import 'package:flutter_test/flutter_test.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:appserap/database/app.database.dart';

import 'generated_migrations/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('upgrade from v15 to v19', () async {
    final connection = await verifier.startAt(15);
    final db = AppDatabase(connection.executor);

    await verifier.migrateAndValidate(db, 19);
  });
}
