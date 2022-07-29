import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:drift/drift.dart';

@DataClassName("ContextoProvaDb")
class ContextosProvaDb extends Table {
  IntColumn get id => integer()();
  TextColumn get titulo => text().nullable()();
  TextColumn get texto => text().nullable()();
  TextColumn get imagemBase64 => text().nullable()();
  IntColumn get ordem => integer()();
  TextColumn get imagem => text().nullable()();
  IntColumn get posicionamento => intEnum<PosicionamentoImagemEnum>().nullable()();
  IntColumn get provaId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
