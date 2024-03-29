// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';

class ProvasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProvasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> ultimaAtualizacao =
      GeneratedColumn<DateTime>('ultima_atualizacao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<int> downloadStatus = GeneratedColumn<int>(
      'download_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> itensQuantidade = GeneratedColumn<int>(
      'itens_quantidade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> tempoAlerta = GeneratedColumn<int>(
      'tempo_alerta', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> tempoExecucao = GeneratedColumn<int>(
      'tempo_execucao', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> tempoExtra = GeneratedColumn<int>(
      'tempo_extra', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
      'data_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
      'data_fim', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> dataInicioProvaAluno =
      GeneratedColumn<DateTime>('data_inicio_prova_aluno', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> dataFimProvaAluno =
      GeneratedColumn<DateTime>('data_fim_prova_aluno', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> senha = GeneratedColumn<String>(
      'senha', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> idDownload = GeneratedColumn<String>(
      'id_download', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> quantidadeRespostaSincronizacao =
      GeneratedColumn<int>(
          'quantidade_resposta_sincronizacao', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> ultimaAlteracao =
      GeneratedColumn<DateTime>('ultima_alteracao', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  late final GeneratedColumn<String> caderno = GeneratedColumn<String>(
      'caderno', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("A"));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        descricao,
        ultimaAtualizacao,
        downloadStatus,
        itensQuantidade,
        tempoAlerta,
        tempoExecucao,
        tempoExtra,
        status,
        dataInicio,
        dataFim,
        dataInicioProvaAluno,
        dataFimProvaAluno,
        senha,
        idDownload,
        quantidadeRespostaSincronizacao,
        ultimaAlteracao,
        caderno
      ];
  @override
  String get aliasedName => _alias ?? 'provas_db';
  @override
  String get actualTableName => 'provas_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, caderno};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ProvasDb createAlias(String alias) {
    return ProvasDb(attachedDatabase, alias);
  }
}

class QuestoesDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  QuestoesDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
      'titulo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> tipo = GeneratedColumn<int>(
      'tipo', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> ultimaAtualizacao =
      GeneratedColumn<DateTime>('ultima_atualizacao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<int> quantidadeAlternativas = GeneratedColumn<int>(
      'quantidade_alternativas', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        questaoLegadoId,
        titulo,
        descricao,
        tipo,
        ultimaAtualizacao,
        quantidadeAlternativas
      ];
  @override
  String get aliasedName => _alias ?? 'questoes_db';
  @override
  String get actualTableName => 'questoes_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  QuestoesDb createAlias(String alias) {
    return QuestoesDb(attachedDatabase, alias);
  }
}

class AlternativasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlternativasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> numeracao = GeneratedColumn<String>(
      'numeracao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, questaoLegadoId, descricao, ordem, numeracao];
  @override
  String get aliasedName => _alias ?? 'alternativas_db';
  @override
  String get actualTableName => 'alternativas_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  AlternativasDb createAlias(String alias) {
    return AlternativasDb(attachedDatabase, alias);
  }
}

class ArquivosDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> legadoId = GeneratedColumn<int>(
      'legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> caminho = GeneratedColumn<String>(
      'caminho', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> base64 = GeneratedColumn<String>(
      'base64', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, legadoId, caminho, base64];
  @override
  String get aliasedName => _alias ?? 'arquivos_db';
  @override
  String get actualTableName => 'arquivos_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ArquivosDb createAlias(String alias) {
    return ArquivosDb(attachedDatabase, alias);
  }
}

class ContextosProvaDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ContextosProvaDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> imagem = GeneratedColumn<String>(
      'imagem', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> imagemBase64 = GeneratedColumn<String>(
      'imagem_base64', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> posicionamento = GeneratedColumn<int>(
      'posicionamento', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
      'titulo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
      'texto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, provaId, imagem, imagemBase64, posicionamento, ordem, titulo, texto];
  @override
  String get aliasedName => _alias ?? 'contextos_prova_db';
  @override
  String get actualTableName => 'contextos_prova_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ContextosProvaDb createAlias(String alias) {
    return ContextosProvaDb(attachedDatabase, alias);
  }
}

class ArquivosVideoDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosVideoDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, questaoLegadoId, path];
  @override
  String get aliasedName => _alias ?? 'arquivos_video_db';
  @override
  String get actualTableName => 'arquivos_video_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ArquivosVideoDb createAlias(String alias) {
    return ArquivosVideoDb(attachedDatabase, alias);
  }
}

class ArquivosAudioDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosAudioDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, questaoLegadoId, path];
  @override
  String get aliasedName => _alias ?? 'arquivos_audio_db';
  @override
  String get actualTableName => 'arquivos_audio_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ArquivosAudioDb createAlias(String alias) {
    return ArquivosAudioDb(attachedDatabase, alias);
  }
}

class DownloadProvasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DownloadProvasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> tipo = GeneratedColumn<int>(
      'tipo', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> downloadStatus = GeneratedColumn<int>(
      'download_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> dataHoraInicio =
      GeneratedColumn<DateTime>('data_hora_inicio', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> dataHoraFim = GeneratedColumn<DateTime>(
      'data_hora_fim', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        provaId,
        questaoLegadoId,
        ordem,
        tipo,
        downloadStatus,
        dataHoraInicio,
        dataHoraFim
      ];
  @override
  String get aliasedName => _alias ?? 'download_provas_db';
  @override
  String get actualTableName => 'download_provas_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, provaId};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  DownloadProvasDb createAlias(String alias) {
    return DownloadProvasDb(attachedDatabase, alias);
  }
}

class ProvaAlunoTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProvaAlunoTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> codigoEOL = GeneratedColumn<String>(
      'codigo_e_o_l', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [codigoEOL, provaId];
  @override
  String get aliasedName => _alias ?? 'prova_aluno_table';
  @override
  String get actualTableName => 'prova_aluno_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {codigoEOL, provaId};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ProvaAlunoTable createAlias(String alias) {
    return ProvaAlunoTable(attachedDatabase, alias);
  }
}

class ProvaCadernoTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProvaCadernoTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> questaoId = GeneratedColumn<int>(
      'questao_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> caderno = GeneratedColumn<String>(
      'caderno', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [questaoId, questaoLegadoId, provaId, caderno, ordem];
  @override
  String get aliasedName => _alias ?? 'prova_caderno_table';
  @override
  String get actualTableName => 'prova_caderno_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId, provaId, caderno};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ProvaCadernoTable createAlias(String alias) {
    return ProvaCadernoTable(attachedDatabase, alias);
  }
}

class QuestaoArquivoTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  QuestaoArquivoTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> arquivoLegadoId = GeneratedColumn<int>(
      'arquivo_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [questaoLegadoId, arquivoLegadoId];
  @override
  String get aliasedName => _alias ?? 'questao_arquivo_table';
  @override
  String get actualTableName => 'questao_arquivo_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId, arquivoLegadoId};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  QuestaoArquivoTable createAlias(String alias) {
    return QuestaoArquivoTable(attachedDatabase, alias);
  }
}

class JobsTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  JobsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> statusUltimaExecucao = GeneratedColumn<int>(
      'status_ultima_execucao', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> ultimaExecucao =
      GeneratedColumn<DateTime>('ultima_execucao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<int> intervalo = GeneratedColumn<int>(
      'intervalo', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, statusUltimaExecucao, ultimaExecucao, intervalo];
  @override
  String get aliasedName => _alias ?? 'jobs_table';
  @override
  String get actualTableName => 'jobs_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  JobsTable createAlias(String alias) {
    return JobsTable(attachedDatabase, alias);
  }
}

class DatabaseAtV22 extends GeneratedDatabase {
  DatabaseAtV22(QueryExecutor e) : super(e);
  late final ProvasDb provasDb = ProvasDb(this);
  late final QuestoesDb questoesDb = QuestoesDb(this);
  late final AlternativasDb alternativasDb = AlternativasDb(this);
  late final ArquivosDb arquivosDb = ArquivosDb(this);
  late final ContextosProvaDb contextosProvaDb = ContextosProvaDb(this);
  late final ArquivosVideoDb arquivosVideoDb = ArquivosVideoDb(this);
  late final ArquivosAudioDb arquivosAudioDb = ArquivosAudioDb(this);
  late final DownloadProvasDb downloadProvasDb = DownloadProvasDb(this);
  late final ProvaAlunoTable provaAlunoTable = ProvaAlunoTable(this);
  late final ProvaCadernoTable provaCadernoTable = ProvaCadernoTable(this);
  late final QuestaoArquivoTable questaoArquivoTable =
      QuestaoArquivoTable(this);
  late final JobsTable jobsTable = JobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        provasDb,
        questoesDb,
        alternativasDb,
        arquivosDb,
        contextosProvaDb,
        arquivosVideoDb,
        arquivosAudioDb,
        downloadProvasDb,
        provaAlunoTable,
        provaCadernoTable,
        questaoArquivoTable,
        jobsTable
      ];
  @override
  int get schemaVersion => 22;
}
