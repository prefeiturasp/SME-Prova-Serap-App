import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Prova)
class ProvasDb extends Table {
  IntColumn get id => integer()();
  TextColumn get descricao => text().withLength(min: 1, max: 150)();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get downloadStatus => intEnum<EnumDownloadStatus>()();
  IntColumn get itensQuantidade => integer()();
  IntColumn get tempoAlerta => integer().nullable()();
  IntColumn get tempoExecucao => integer()();
  IntColumn get tempoExtra => integer()();
  IntColumn get status => intEnum<EnumProvaStatus>()();

  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime().nullable()();

  DateTimeColumn get dataInicioProvaAluno => dateTime().nullable()();
  DateTimeColumn get dataFimProvaAluno => dateTime().nullable()();

  TextColumn get senha => text().nullable()();
  TextColumn get idDownload => text().nullable()();

  IntColumn get quantidadeRespostaSincronizacao => integer()();
  DateTimeColumn get ultimaAlteracao => dateTime().withDefault(currentDateAndTime)();

  TextColumn get caderno => text().withDefault(Constant("A"))();

  @override
  Set<Column> get primaryKey => {id};
}
