// GENERATED CODE, DO NOT EDIT BY HAND.
//@dart=2.12
import 'package:drift/drift.dart';

class ProvasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProvasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: const StringType(),
      requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> ultimaAtualizacao =
      GeneratedColumn<DateTime?>('ultima_atualizacao', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> downloadStatus = GeneratedColumn<int?>(
      'download_status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> itensQuantidade = GeneratedColumn<int?>(
      'itens_quantidade', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> tempoAlerta = GeneratedColumn<int?>(
      'tempo_alerta', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> tempoExecucao = GeneratedColumn<int?>(
      'tempo_execucao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> tempoExtra = GeneratedColumn<int?>(
      'tempo_extra', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> dataInicio = GeneratedColumn<DateTime?>(
      'data_inicio', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> dataFim = GeneratedColumn<DateTime?>(
      'data_fim', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<DateTime?> dataInicioProvaAluno =
      GeneratedColumn<DateTime?>('data_inicio_prova_aluno', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<DateTime?> dataFimProvaAluno =
      GeneratedColumn<DateTime?>('data_fim_prova_aluno', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> senha = GeneratedColumn<String?>(
      'senha', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> idDownload = GeneratedColumn<String?>(
      'id_download', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> quantidadeRespostaSincronizacao =
      GeneratedColumn<int?>(
          'quantidade_resposta_sincronizacao', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> ultimaAlteracao =
      GeneratedColumn<DateTime?>('ultima_alteracao', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
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
        ultimaAlteracao
      ];
  @override
  String get aliasedName => _alias ?? 'provas_db';
  @override
  String get actualTableName => 'provas_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  ProvasDb createAlias(String alias) {
    return ProvasDb(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class QuestoesDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  QuestoesDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> ordem = GeneratedColumn<int?>(
      'ordem', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> tipo = GeneratedColumn<int?>(
      'tipo', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> ultimaAtualizacao =
      GeneratedColumn<DateTime?>('ultima_atualizacao', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> quantidadeAlternativas =
      GeneratedColumn<int?>('quantidade_alternativas', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        titulo,
        descricao,
        ordem,
        tipo,
        ultimaAtualizacao,
        provaId,
        quantidadeAlternativas
      ];
  @override
  String get aliasedName => _alias ?? 'questoes_db';
  @override
  String get actualTableName => 'questoes_db';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  QuestoesDb createAlias(String alias) {
    return QuestoesDb(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class AlternativasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlternativasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> ordem = GeneratedColumn<int?>(
      'ordem', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<String?> numeracao = GeneratedColumn<String?>(
      'numeracao', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> ultimaAtualizacao =
      GeneratedColumn<DateTime?>('ultima_atualizacao', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> questaoId = GeneratedColumn<int?>(
      'questao_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descricao, ordem, numeracao, ultimaAtualizacao, provaId, questaoId];
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

  @override
  bool get dontWriteConstraints => false;
}

class ArquivosDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> legadoId = GeneratedColumn<int?>(
      'legado_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> caminho = GeneratedColumn<String?>(
      'caminho', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<String?> base64 = GeneratedColumn<String?>(
      'base64', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> ultimaAtualizacao =
      GeneratedColumn<DateTime?>('ultima_atualizacao', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> questaoId = GeneratedColumn<int?>(
      'questao_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, legadoId, caminho, base64, ultimaAtualizacao, provaId, questaoId];
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

  @override
  bool get dontWriteConstraints => false;
}

class ContextosProvaDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ContextosProvaDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> texto = GeneratedColumn<String?>(
      'texto', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> imagemBase64 = GeneratedColumn<String?>(
      'imagem_base64', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> ordem = GeneratedColumn<int?>(
      'ordem', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<String?> imagem = GeneratedColumn<String?>(
      'imagem', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> posicionamento = GeneratedColumn<int?>(
      'posicionamento', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, titulo, texto, imagemBase64, ordem, imagem, posicionamento, provaId];
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

  @override
  bool get dontWriteConstraints => false;
}

class ArquivosVideoDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosVideoDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> path = GeneratedColumn<String?>(
      'path', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> questaoId = GeneratedColumn<int?>(
      'questao_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, path, questaoId, provaId];
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

  @override
  bool get dontWriteConstraints => false;
}

class ArquivosAudioDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArquivosAudioDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> path = GeneratedColumn<String?>(
      'path', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> questaoId = GeneratedColumn<int?>(
      'questao_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, path, questaoId, provaId];
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

  @override
  bool get dontWriteConstraints => false;
}

class DownloadProvasDb extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DownloadProvasDb(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> tipo = GeneratedColumn<int?>(
      'tipo', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> downloadStatus = GeneratedColumn<int?>(
      'download_status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> dataHoraInicio =
      GeneratedColumn<DateTime?>('data_hora_inicio', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<DateTime?> dataHoraFim =
      GeneratedColumn<DateTime?>('data_hora_fim', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, provaId, tipo, downloadStatus, dataHoraInicio, dataHoraFim];
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

  @override
  bool get dontWriteConstraints => false;
}

class RespostaProvaTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RespostaProvaTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String?> codigoEOL = GeneratedColumn<String?>(
      'codigo_e_o_l', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> questaoId = GeneratedColumn<int?>(
      'questao_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> alternativaId = GeneratedColumn<int?>(
      'alternativa_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<String?> resposta = GeneratedColumn<String?>(
      'resposta', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  late final GeneratedColumn<int?> tempoRespostaAluno = GeneratedColumn<int?>(
      'tempo_resposta_aluno', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  late final GeneratedColumn<DateTime?> dataHoraResposta =
      GeneratedColumn<DateTime?>('data_hora_resposta', aliasedName, true,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  late final GeneratedColumn<bool?> sincronizado = GeneratedColumn<bool?>(
      'sincronizado', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (sincronizado IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [
        codigoEOL,
        questaoId,
        provaId,
        alternativaId,
        resposta,
        tempoRespostaAluno,
        dataHoraResposta,
        sincronizado
      ];
  @override
  String get aliasedName => _alias ?? 'resposta_prova_table';
  @override
  String get actualTableName => 'resposta_prova_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {codigoEOL, provaId, questaoId};
  @override
  Never map(Map<String, dynamic> data, {String? tablePrefix}) {
    throw UnsupportedError('TableInfo.map in schema verification code');
  }

  @override
  RespostaProvaTable createAlias(String alias) {
    return RespostaProvaTable(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class ProvaAlunoTable extends Table with TableInfo {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProvaAlunoTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String?> codigoEOL = GeneratedColumn<String?>(
      'codigo_e_o_l', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> provaId = GeneratedColumn<int?>(
      'prova_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
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

  @override
  bool get dontWriteConstraints => false;
}

class DatabaseAtV15 extends GeneratedDatabase {
  DatabaseAtV15(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final ProvasDb provasDb = ProvasDb(this);
  late final QuestoesDb questoesDb = QuestoesDb(this);
  late final AlternativasDb alternativasDb = AlternativasDb(this);
  late final ArquivosDb arquivosDb = ArquivosDb(this);
  late final ContextosProvaDb contextosProvaDb = ContextosProvaDb(this);
  late final ArquivosVideoDb arquivosVideoDb = ArquivosVideoDb(this);
  late final ArquivosAudioDb arquivosAudioDb = ArquivosAudioDb(this);
  late final DownloadProvasDb downloadProvasDb = DownloadProvasDb(this);
  late final RespostaProvaTable respostaProvaTable = RespostaProvaTable(this);
  late final ProvaAlunoTable provaAlunoTable = ProvaAlunoTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
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
        respostaProvaTable,
        provaAlunoTable
      ];
  @override
  int get schemaVersion => 15;
}
