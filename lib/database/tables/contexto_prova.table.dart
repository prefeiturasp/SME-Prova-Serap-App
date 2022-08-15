import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:drift/drift.dart';

import 'prova.table.dart';

@UseRowClass(ContextoProva)
class ContextosProvaDb extends Table {
  IntColumn get id => integer()();
  IntColumn get provaId => integer()();
  TextColumn get imagem => text()();
  TextColumn get imagemBase64 => text()();
  IntColumn get posicionamento => intEnum<PosicionamentoImagemEnum>()();
  IntColumn get ordem => integer()();
  TextColumn get titulo => text()();
  TextColumn get texto => text()();

  @override
  Set<Column> get primaryKey => {id};
}
