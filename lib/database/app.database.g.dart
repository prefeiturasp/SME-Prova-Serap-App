// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ProvasDbCompanion extends UpdateCompanion<Prova> {
  final Value<int> id;
  final Value<String> descricao;
  final Value<DateTime?> ultimaAtualizacao;
  final Value<EnumDownloadStatus> downloadStatus;
  final Value<int> itensQuantidade;
  final Value<int?> tempoAlerta;
  final Value<int> tempoExecucao;
  final Value<int> tempoExtra;
  final Value<EnumProvaStatus> status;
  final Value<DateTime> dataInicio;
  final Value<DateTime?> dataFim;
  final Value<DateTime?> dataInicioProvaAluno;
  final Value<DateTime?> dataFimProvaAluno;
  final Value<String?> senha;
  final Value<String?> idDownload;
  final Value<int> quantidadeRespostaSincronizacao;
  final Value<DateTime> ultimaAlteracao;
  final Value<String> caderno;
  const ProvasDbCompanion({
    this.id = const Value.absent(),
    this.descricao = const Value.absent(),
    this.ultimaAtualizacao = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.itensQuantidade = const Value.absent(),
    this.tempoAlerta = const Value.absent(),
    this.tempoExecucao = const Value.absent(),
    this.tempoExtra = const Value.absent(),
    this.status = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
    this.dataInicioProvaAluno = const Value.absent(),
    this.dataFimProvaAluno = const Value.absent(),
    this.senha = const Value.absent(),
    this.idDownload = const Value.absent(),
    this.quantidadeRespostaSincronizacao = const Value.absent(),
    this.ultimaAlteracao = const Value.absent(),
    this.caderno = const Value.absent(),
  });
  ProvasDbCompanion.insert({
    required int id,
    required String descricao,
    this.ultimaAtualizacao = const Value.absent(),
    required EnumDownloadStatus downloadStatus,
    required int itensQuantidade,
    this.tempoAlerta = const Value.absent(),
    required int tempoExecucao,
    required int tempoExtra,
    required EnumProvaStatus status,
    required DateTime dataInicio,
    this.dataFim = const Value.absent(),
    this.dataInicioProvaAluno = const Value.absent(),
    this.dataFimProvaAluno = const Value.absent(),
    this.senha = const Value.absent(),
    this.idDownload = const Value.absent(),
    required int quantidadeRespostaSincronizacao,
    this.ultimaAlteracao = const Value.absent(),
    this.caderno = const Value.absent(),
  })  : id = Value(id),
        descricao = Value(descricao),
        downloadStatus = Value(downloadStatus),
        itensQuantidade = Value(itensQuantidade),
        tempoExecucao = Value(tempoExecucao),
        tempoExtra = Value(tempoExtra),
        status = Value(status),
        dataInicio = Value(dataInicio),
        quantidadeRespostaSincronizacao =
            Value(quantidadeRespostaSincronizacao);
  static Insertable<Prova> custom({
    Expression<int>? id,
    Expression<String>? descricao,
    Expression<DateTime>? ultimaAtualizacao,
    Expression<int>? downloadStatus,
    Expression<int>? itensQuantidade,
    Expression<int>? tempoAlerta,
    Expression<int>? tempoExecucao,
    Expression<int>? tempoExtra,
    Expression<int>? status,
    Expression<DateTime>? dataInicio,
    Expression<DateTime>? dataFim,
    Expression<DateTime>? dataInicioProvaAluno,
    Expression<DateTime>? dataFimProvaAluno,
    Expression<String>? senha,
    Expression<String>? idDownload,
    Expression<int>? quantidadeRespostaSincronizacao,
    Expression<DateTime>? ultimaAlteracao,
    Expression<String>? caderno,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descricao != null) 'descricao': descricao,
      if (ultimaAtualizacao != null) 'ultima_atualizacao': ultimaAtualizacao,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (itensQuantidade != null) 'itens_quantidade': itensQuantidade,
      if (tempoAlerta != null) 'tempo_alerta': tempoAlerta,
      if (tempoExecucao != null) 'tempo_execucao': tempoExecucao,
      if (tempoExtra != null) 'tempo_extra': tempoExtra,
      if (status != null) 'status': status,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
      if (dataInicioProvaAluno != null)
        'data_inicio_prova_aluno': dataInicioProvaAluno,
      if (dataFimProvaAluno != null) 'data_fim_prova_aluno': dataFimProvaAluno,
      if (senha != null) 'senha': senha,
      if (idDownload != null) 'id_download': idDownload,
      if (quantidadeRespostaSincronizacao != null)
        'quantidade_resposta_sincronizacao': quantidadeRespostaSincronizacao,
      if (ultimaAlteracao != null) 'ultima_alteracao': ultimaAlteracao,
      if (caderno != null) 'caderno': caderno,
    });
  }

  ProvasDbCompanion copyWith(
      {Value<int>? id,
      Value<String>? descricao,
      Value<DateTime?>? ultimaAtualizacao,
      Value<EnumDownloadStatus>? downloadStatus,
      Value<int>? itensQuantidade,
      Value<int?>? tempoAlerta,
      Value<int>? tempoExecucao,
      Value<int>? tempoExtra,
      Value<EnumProvaStatus>? status,
      Value<DateTime>? dataInicio,
      Value<DateTime?>? dataFim,
      Value<DateTime?>? dataInicioProvaAluno,
      Value<DateTime?>? dataFimProvaAluno,
      Value<String?>? senha,
      Value<String?>? idDownload,
      Value<int>? quantidadeRespostaSincronizacao,
      Value<DateTime>? ultimaAlteracao,
      Value<String>? caderno}) {
    return ProvasDbCompanion(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      itensQuantidade: itensQuantidade ?? this.itensQuantidade,
      tempoAlerta: tempoAlerta ?? this.tempoAlerta,
      tempoExecucao: tempoExecucao ?? this.tempoExecucao,
      tempoExtra: tempoExtra ?? this.tempoExtra,
      status: status ?? this.status,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      dataInicioProvaAluno: dataInicioProvaAluno ?? this.dataInicioProvaAluno,
      dataFimProvaAluno: dataFimProvaAluno ?? this.dataFimProvaAluno,
      senha: senha ?? this.senha,
      idDownload: idDownload ?? this.idDownload,
      quantidadeRespostaSincronizacao: quantidadeRespostaSincronizacao ??
          this.quantidadeRespostaSincronizacao,
      ultimaAlteracao: ultimaAlteracao ?? this.ultimaAlteracao,
      caderno: caderno ?? this.caderno,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (ultimaAtualizacao.present) {
      map['ultima_atualizacao'] = Variable<DateTime>(ultimaAtualizacao.value);
    }
    if (downloadStatus.present) {
      final converter = $ProvasDbTable.$converter0;
      map['download_status'] =
          Variable<int>(converter.toSql(downloadStatus.value));
    }
    if (itensQuantidade.present) {
      map['itens_quantidade'] = Variable<int>(itensQuantidade.value);
    }
    if (tempoAlerta.present) {
      map['tempo_alerta'] = Variable<int>(tempoAlerta.value);
    }
    if (tempoExecucao.present) {
      map['tempo_execucao'] = Variable<int>(tempoExecucao.value);
    }
    if (tempoExtra.present) {
      map['tempo_extra'] = Variable<int>(tempoExtra.value);
    }
    if (status.present) {
      final converter = $ProvasDbTable.$converter1;
      map['status'] = Variable<int>(converter.toSql(status.value));
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<DateTime>(dataInicio.value);
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<DateTime>(dataFim.value);
    }
    if (dataInicioProvaAluno.present) {
      map['data_inicio_prova_aluno'] =
          Variable<DateTime>(dataInicioProvaAluno.value);
    }
    if (dataFimProvaAluno.present) {
      map['data_fim_prova_aluno'] = Variable<DateTime>(dataFimProvaAluno.value);
    }
    if (senha.present) {
      map['senha'] = Variable<String>(senha.value);
    }
    if (idDownload.present) {
      map['id_download'] = Variable<String>(idDownload.value);
    }
    if (quantidadeRespostaSincronizacao.present) {
      map['quantidade_resposta_sincronizacao'] =
          Variable<int>(quantidadeRespostaSincronizacao.value);
    }
    if (ultimaAlteracao.present) {
      map['ultima_alteracao'] = Variable<DateTime>(ultimaAlteracao.value);
    }
    if (caderno.present) {
      map['caderno'] = Variable<String>(caderno.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvasDbCompanion(')
          ..write('id: $id, ')
          ..write('descricao: $descricao, ')
          ..write('ultimaAtualizacao: $ultimaAtualizacao, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('itensQuantidade: $itensQuantidade, ')
          ..write('tempoAlerta: $tempoAlerta, ')
          ..write('tempoExecucao: $tempoExecucao, ')
          ..write('tempoExtra: $tempoExtra, ')
          ..write('status: $status, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('dataInicioProvaAluno: $dataInicioProvaAluno, ')
          ..write('dataFimProvaAluno: $dataFimProvaAluno, ')
          ..write('senha: $senha, ')
          ..write('idDownload: $idDownload, ')
          ..write(
              'quantidadeRespostaSincronizacao: $quantidadeRespostaSincronizacao, ')
          ..write('ultimaAlteracao: $ultimaAlteracao, ')
          ..write('caderno: $caderno')
          ..write(')'))
        .toString();
  }
}

class $ProvasDbTable extends ProvasDb with TableInfo<$ProvasDbTable, Prova> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvasDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _ultimaAtualizacaoMeta =
      const VerificationMeta('ultimaAtualizacao');
  @override
  late final GeneratedColumn<DateTime> ultimaAtualizacao =
      GeneratedColumn<DateTime>('ultima_atualizacao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _downloadStatusMeta =
      const VerificationMeta('downloadStatus');
  @override
  late final GeneratedColumnWithTypeConverter<EnumDownloadStatus, int>
      downloadStatus = GeneratedColumn<int>(
              'download_status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EnumDownloadStatus>($ProvasDbTable.$converter0);
  final VerificationMeta _itensQuantidadeMeta =
      const VerificationMeta('itensQuantidade');
  @override
  late final GeneratedColumn<int> itensQuantidade = GeneratedColumn<int>(
      'itens_quantidade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _tempoAlertaMeta =
      const VerificationMeta('tempoAlerta');
  @override
  late final GeneratedColumn<int> tempoAlerta = GeneratedColumn<int>(
      'tempo_alerta', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _tempoExecucaoMeta =
      const VerificationMeta('tempoExecucao');
  @override
  late final GeneratedColumn<int> tempoExecucao = GeneratedColumn<int>(
      'tempo_execucao', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _tempoExtraMeta = const VerificationMeta('tempoExtra');
  @override
  late final GeneratedColumn<int> tempoExtra = GeneratedColumn<int>(
      'tempo_extra', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<EnumProvaStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EnumProvaStatus>($ProvasDbTable.$converter1);
  final VerificationMeta _dataInicioMeta = const VerificationMeta('dataInicio');
  @override
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
      'data_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _dataFimMeta = const VerificationMeta('dataFim');
  @override
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
      'data_fim', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _dataInicioProvaAlunoMeta =
      const VerificationMeta('dataInicioProvaAluno');
  @override
  late final GeneratedColumn<DateTime> dataInicioProvaAluno =
      GeneratedColumn<DateTime>('data_inicio_prova_aluno', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _dataFimProvaAlunoMeta =
      const VerificationMeta('dataFimProvaAluno');
  @override
  late final GeneratedColumn<DateTime> dataFimProvaAluno =
      GeneratedColumn<DateTime>('data_fim_prova_aluno', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _senhaMeta = const VerificationMeta('senha');
  @override
  late final GeneratedColumn<String> senha = GeneratedColumn<String>(
      'senha', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _idDownloadMeta = const VerificationMeta('idDownload');
  @override
  late final GeneratedColumn<String> idDownload = GeneratedColumn<String>(
      'id_download', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _quantidadeRespostaSincronizacaoMeta =
      const VerificationMeta('quantidadeRespostaSincronizacao');
  @override
  late final GeneratedColumn<int> quantidadeRespostaSincronizacao =
      GeneratedColumn<int>(
          'quantidade_resposta_sincronizacao', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _ultimaAlteracaoMeta =
      const VerificationMeta('ultimaAlteracao');
  @override
  late final GeneratedColumn<DateTime> ultimaAlteracao =
      GeneratedColumn<DateTime>('ultima_alteracao', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  final VerificationMeta _cadernoMeta = const VerificationMeta('caderno');
  @override
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
  VerificationContext validateIntegrity(Insertable<Prova> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('ultima_atualizacao')) {
      context.handle(
          _ultimaAtualizacaoMeta,
          ultimaAtualizacao.isAcceptableOrUnknown(
              data['ultima_atualizacao']!, _ultimaAtualizacaoMeta));
    }
    context.handle(_downloadStatusMeta, const VerificationResult.success());
    if (data.containsKey('itens_quantidade')) {
      context.handle(
          _itensQuantidadeMeta,
          itensQuantidade.isAcceptableOrUnknown(
              data['itens_quantidade']!, _itensQuantidadeMeta));
    } else if (isInserting) {
      context.missing(_itensQuantidadeMeta);
    }
    if (data.containsKey('tempo_alerta')) {
      context.handle(
          _tempoAlertaMeta,
          tempoAlerta.isAcceptableOrUnknown(
              data['tempo_alerta']!, _tempoAlertaMeta));
    }
    if (data.containsKey('tempo_execucao')) {
      context.handle(
          _tempoExecucaoMeta,
          tempoExecucao.isAcceptableOrUnknown(
              data['tempo_execucao']!, _tempoExecucaoMeta));
    } else if (isInserting) {
      context.missing(_tempoExecucaoMeta);
    }
    if (data.containsKey('tempo_extra')) {
      context.handle(
          _tempoExtraMeta,
          tempoExtra.isAcceptableOrUnknown(
              data['tempo_extra']!, _tempoExtraMeta));
    } else if (isInserting) {
      context.missing(_tempoExtraMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('data_inicio')) {
      context.handle(
          _dataInicioMeta,
          dataInicio.isAcceptableOrUnknown(
              data['data_inicio']!, _dataInicioMeta));
    } else if (isInserting) {
      context.missing(_dataInicioMeta);
    }
    if (data.containsKey('data_fim')) {
      context.handle(_dataFimMeta,
          dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta));
    }
    if (data.containsKey('data_inicio_prova_aluno')) {
      context.handle(
          _dataInicioProvaAlunoMeta,
          dataInicioProvaAluno.isAcceptableOrUnknown(
              data['data_inicio_prova_aluno']!, _dataInicioProvaAlunoMeta));
    }
    if (data.containsKey('data_fim_prova_aluno')) {
      context.handle(
          _dataFimProvaAlunoMeta,
          dataFimProvaAluno.isAcceptableOrUnknown(
              data['data_fim_prova_aluno']!, _dataFimProvaAlunoMeta));
    }
    if (data.containsKey('senha')) {
      context.handle(
          _senhaMeta, senha.isAcceptableOrUnknown(data['senha']!, _senhaMeta));
    }
    if (data.containsKey('id_download')) {
      context.handle(
          _idDownloadMeta,
          idDownload.isAcceptableOrUnknown(
              data['id_download']!, _idDownloadMeta));
    }
    if (data.containsKey('quantidade_resposta_sincronizacao')) {
      context.handle(
          _quantidadeRespostaSincronizacaoMeta,
          quantidadeRespostaSincronizacao.isAcceptableOrUnknown(
              data['quantidade_resposta_sincronizacao']!,
              _quantidadeRespostaSincronizacaoMeta));
    } else if (isInserting) {
      context.missing(_quantidadeRespostaSincronizacaoMeta);
    }
    if (data.containsKey('ultima_alteracao')) {
      context.handle(
          _ultimaAlteracaoMeta,
          ultimaAlteracao.isAcceptableOrUnknown(
              data['ultima_alteracao']!, _ultimaAlteracaoMeta));
    }
    if (data.containsKey('caderno')) {
      context.handle(_cadernoMeta,
          caderno.isAcceptableOrUnknown(data['caderno']!, _cadernoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, caderno};
  @override
  Prova map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prova(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      descricao: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}descricao'])!,
      itensQuantidade: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}itens_quantidade'])!,
      dataInicio: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_inicio'])!,
      dataFim: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_fim']),
      tempoExecucao: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}tempo_execucao'])!,
      tempoExtra: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}tempo_extra'])!,
      tempoAlerta: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}tempo_alerta']),
      downloadStatus: $ProvasDbTable.$converter0.fromSql(attachedDatabase
          .options.types
          .read(DriftSqlType.int, data['${effectivePrefix}download_status'])!),
      idDownload: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id_download']),
      status: $ProvasDbTable.$converter1.fromSql(attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      senha: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}senha']),
      dataInicioProvaAluno: attachedDatabase.options.types.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}data_inicio_prova_aluno']),
      dataFimProvaAluno: attachedDatabase.options.types.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}data_fim_prova_aluno']),
      quantidadeRespostaSincronizacao: attachedDatabase.options.types.read(
          DriftSqlType.int,
          data['${effectivePrefix}quantidade_resposta_sincronizacao'])!,
      ultimaAlteracao: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}ultima_alteracao'])!,
      caderno: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}caderno'])!,
    );
  }

  @override
  $ProvasDbTable createAlias(String alias) {
    return $ProvasDbTable(attachedDatabase, alias);
  }

  static TypeConverter<EnumDownloadStatus, int> $converter0 =
      const EnumIndexConverter<EnumDownloadStatus>(EnumDownloadStatus.values);
  static TypeConverter<EnumProvaStatus, int> $converter1 =
      const EnumIndexConverter<EnumProvaStatus>(EnumProvaStatus.values);
}

class QuestoesDbCompanion extends UpdateCompanion<Questao> {
  final Value<int> questaoLegadoId;
  final Value<String?> titulo;
  final Value<String> descricao;
  final Value<EnumTipoQuestao> tipo;
  final Value<DateTime?> ultimaAtualizacao;
  final Value<int> quantidadeAlternativas;
  const QuestoesDbCompanion({
    this.questaoLegadoId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipo = const Value.absent(),
    this.ultimaAtualizacao = const Value.absent(),
    this.quantidadeAlternativas = const Value.absent(),
  });
  QuestoesDbCompanion.insert({
    this.questaoLegadoId = const Value.absent(),
    this.titulo = const Value.absent(),
    required String descricao,
    required EnumTipoQuestao tipo,
    this.ultimaAtualizacao = const Value.absent(),
    required int quantidadeAlternativas,
  })  : descricao = Value(descricao),
        tipo = Value(tipo),
        quantidadeAlternativas = Value(quantidadeAlternativas);
  static Insertable<Questao> custom({
    Expression<int>? questaoLegadoId,
    Expression<String>? titulo,
    Expression<String>? descricao,
    Expression<int>? tipo,
    Expression<DateTime>? ultimaAtualizacao,
    Expression<int>? quantidadeAlternativas,
  }) {
    return RawValuesInsertable({
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (titulo != null) 'titulo': titulo,
      if (descricao != null) 'descricao': descricao,
      if (tipo != null) 'tipo': tipo,
      if (ultimaAtualizacao != null) 'ultima_atualizacao': ultimaAtualizacao,
      if (quantidadeAlternativas != null)
        'quantidade_alternativas': quantidadeAlternativas,
    });
  }

  QuestoesDbCompanion copyWith(
      {Value<int>? questaoLegadoId,
      Value<String?>? titulo,
      Value<String>? descricao,
      Value<EnumTipoQuestao>? tipo,
      Value<DateTime?>? ultimaAtualizacao,
      Value<int>? quantidadeAlternativas}) {
    return QuestoesDbCompanion(
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,
      quantidadeAlternativas:
          quantidadeAlternativas ?? this.quantidadeAlternativas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipo.present) {
      final converter = $QuestoesDbTable.$converter0;
      map['tipo'] = Variable<int>(converter.toSql(tipo.value));
    }
    if (ultimaAtualizacao.present) {
      map['ultima_atualizacao'] = Variable<DateTime>(ultimaAtualizacao.value);
    }
    if (quantidadeAlternativas.present) {
      map['quantidade_alternativas'] =
          Variable<int>(quantidadeAlternativas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestoesDbCompanion(')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('ultimaAtualizacao: $ultimaAtualizacao, ')
          ..write('quantidadeAlternativas: $quantidadeAlternativas')
          ..write(')'))
        .toString();
  }
}

class $QuestoesDbTable extends QuestoesDb
    with TableInfo<$QuestoesDbTable, Questao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestoesDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
      'titulo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumnWithTypeConverter<EnumTipoQuestao, int> tipo =
      GeneratedColumn<int>('tipo', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EnumTipoQuestao>($QuestoesDbTable.$converter0);
  final VerificationMeta _ultimaAtualizacaoMeta =
      const VerificationMeta('ultimaAtualizacao');
  @override
  late final GeneratedColumn<DateTime> ultimaAtualizacao =
      GeneratedColumn<DateTime>('ultima_atualizacao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _quantidadeAlternativasMeta =
      const VerificationMeta('quantidadeAlternativas');
  @override
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
  VerificationContext validateIntegrity(Insertable<Questao> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    if (data.containsKey('ultima_atualizacao')) {
      context.handle(
          _ultimaAtualizacaoMeta,
          ultimaAtualizacao.isAcceptableOrUnknown(
              data['ultima_atualizacao']!, _ultimaAtualizacaoMeta));
    }
    if (data.containsKey('quantidade_alternativas')) {
      context.handle(
          _quantidadeAlternativasMeta,
          quantidadeAlternativas.isAcceptableOrUnknown(
              data['quantidade_alternativas']!, _quantidadeAlternativasMeta));
    } else if (isInserting) {
      context.missing(_quantidadeAlternativasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId};
  @override
  Questao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Questao(
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
      titulo: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}titulo']),
      descricao: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}descricao'])!,
      tipo: $QuestoesDbTable.$converter0.fromSql(attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}tipo'])!),
      quantidadeAlternativas: attachedDatabase.options.types.read(
          DriftSqlType.int, data['${effectivePrefix}quantidade_alternativas'])!,
    );
  }

  @override
  $QuestoesDbTable createAlias(String alias) {
    return $QuestoesDbTable(attachedDatabase, alias);
  }

  static TypeConverter<EnumTipoQuestao, int> $converter0 =
      const EnumIndexConverter<EnumTipoQuestao>(EnumTipoQuestao.values);
}

class AlternativasDbCompanion extends UpdateCompanion<Alternativa> {
  final Value<int> id;
  final Value<int> questaoLegadoId;
  final Value<String> descricao;
  final Value<int> ordem;
  final Value<String> numeracao;
  const AlternativasDbCompanion({
    this.id = const Value.absent(),
    this.questaoLegadoId = const Value.absent(),
    this.descricao = const Value.absent(),
    this.ordem = const Value.absent(),
    this.numeracao = const Value.absent(),
  });
  AlternativasDbCompanion.insert({
    this.id = const Value.absent(),
    required int questaoLegadoId,
    required String descricao,
    required int ordem,
    required String numeracao,
  })  : questaoLegadoId = Value(questaoLegadoId),
        descricao = Value(descricao),
        ordem = Value(ordem),
        numeracao = Value(numeracao);
  static Insertable<Alternativa> custom({
    Expression<int>? id,
    Expression<int>? questaoLegadoId,
    Expression<String>? descricao,
    Expression<int>? ordem,
    Expression<String>? numeracao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (descricao != null) 'descricao': descricao,
      if (ordem != null) 'ordem': ordem,
      if (numeracao != null) 'numeracao': numeracao,
    });
  }

  AlternativasDbCompanion copyWith(
      {Value<int>? id,
      Value<int>? questaoLegadoId,
      Value<String>? descricao,
      Value<int>? ordem,
      Value<String>? numeracao}) {
    return AlternativasDbCompanion(
      id: id ?? this.id,
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      descricao: descricao ?? this.descricao,
      ordem: ordem ?? this.ordem,
      numeracao: numeracao ?? this.numeracao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (numeracao.present) {
      map['numeracao'] = Variable<String>(numeracao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlternativasDbCompanion(')
          ..write('id: $id, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('descricao: $descricao, ')
          ..write('ordem: $ordem, ')
          ..write('numeracao: $numeracao')
          ..write(')'))
        .toString();
  }
}

class $AlternativasDbTable extends AlternativasDb
    with TableInfo<$AlternativasDbTable, Alternativa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlternativasDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _numeracaoMeta = const VerificationMeta('numeracao');
  @override
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
  VerificationContext validateIntegrity(Insertable<Alternativa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoLegadoIdMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    if (data.containsKey('numeracao')) {
      context.handle(_numeracaoMeta,
          numeracao.isAcceptableOrUnknown(data['numeracao']!, _numeracaoMeta));
    } else if (isInserting) {
      context.missing(_numeracaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alternativa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alternativa(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
      descricao: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}descricao'])!,
      ordem: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}ordem'])!,
      numeracao: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}numeracao'])!,
    );
  }

  @override
  $AlternativasDbTable createAlias(String alias) {
    return $AlternativasDbTable(attachedDatabase, alias);
  }
}

class ArquivosDbCompanion extends UpdateCompanion<Arquivo> {
  final Value<int> id;
  final Value<int> legadoId;
  final Value<String> caminho;
  final Value<String> base64;
  const ArquivosDbCompanion({
    this.id = const Value.absent(),
    this.legadoId = const Value.absent(),
    this.caminho = const Value.absent(),
    this.base64 = const Value.absent(),
  });
  ArquivosDbCompanion.insert({
    this.id = const Value.absent(),
    required int legadoId,
    required String caminho,
    required String base64,
  })  : legadoId = Value(legadoId),
        caminho = Value(caminho),
        base64 = Value(base64);
  static Insertable<Arquivo> custom({
    Expression<int>? id,
    Expression<int>? legadoId,
    Expression<String>? caminho,
    Expression<String>? base64,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (legadoId != null) 'legado_id': legadoId,
      if (caminho != null) 'caminho': caminho,
      if (base64 != null) 'base64': base64,
    });
  }

  ArquivosDbCompanion copyWith(
      {Value<int>? id,
      Value<int>? legadoId,
      Value<String>? caminho,
      Value<String>? base64}) {
    return ArquivosDbCompanion(
      id: id ?? this.id,
      legadoId: legadoId ?? this.legadoId,
      caminho: caminho ?? this.caminho,
      base64: base64 ?? this.base64,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (legadoId.present) {
      map['legado_id'] = Variable<int>(legadoId.value);
    }
    if (caminho.present) {
      map['caminho'] = Variable<String>(caminho.value);
    }
    if (base64.present) {
      map['base64'] = Variable<String>(base64.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArquivosDbCompanion(')
          ..write('id: $id, ')
          ..write('legadoId: $legadoId, ')
          ..write('caminho: $caminho, ')
          ..write('base64: $base64')
          ..write(')'))
        .toString();
  }
}

class $ArquivosDbTable extends ArquivosDb
    with TableInfo<$ArquivosDbTable, Arquivo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArquivosDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _legadoIdMeta = const VerificationMeta('legadoId');
  @override
  late final GeneratedColumn<int> legadoId = GeneratedColumn<int>(
      'legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _caminhoMeta = const VerificationMeta('caminho');
  @override
  late final GeneratedColumn<String> caminho = GeneratedColumn<String>(
      'caminho', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _base64Meta = const VerificationMeta('base64');
  @override
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
  VerificationContext validateIntegrity(Insertable<Arquivo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('legado_id')) {
      context.handle(_legadoIdMeta,
          legadoId.isAcceptableOrUnknown(data['legado_id']!, _legadoIdMeta));
    } else if (isInserting) {
      context.missing(_legadoIdMeta);
    }
    if (data.containsKey('caminho')) {
      context.handle(_caminhoMeta,
          caminho.isAcceptableOrUnknown(data['caminho']!, _caminhoMeta));
    } else if (isInserting) {
      context.missing(_caminhoMeta);
    }
    if (data.containsKey('base64')) {
      context.handle(_base64Meta,
          base64.isAcceptableOrUnknown(data['base64']!, _base64Meta));
    } else if (isInserting) {
      context.missing(_base64Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Arquivo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Arquivo(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      legadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}legado_id'])!,
      caminho: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}caminho'])!,
      base64: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}base64'])!,
    );
  }

  @override
  $ArquivosDbTable createAlias(String alias) {
    return $ArquivosDbTable(attachedDatabase, alias);
  }
}

class ContextosProvaDbCompanion extends UpdateCompanion<ContextoProva> {
  final Value<int> id;
  final Value<int> provaId;
  final Value<String> imagem;
  final Value<String> imagemBase64;
  final Value<PosicionamentoImagemEnum> posicionamento;
  final Value<int> ordem;
  final Value<String> titulo;
  final Value<String> texto;
  const ContextosProvaDbCompanion({
    this.id = const Value.absent(),
    this.provaId = const Value.absent(),
    this.imagem = const Value.absent(),
    this.imagemBase64 = const Value.absent(),
    this.posicionamento = const Value.absent(),
    this.ordem = const Value.absent(),
    this.titulo = const Value.absent(),
    this.texto = const Value.absent(),
  });
  ContextosProvaDbCompanion.insert({
    this.id = const Value.absent(),
    required int provaId,
    required String imagem,
    required String imagemBase64,
    required PosicionamentoImagemEnum posicionamento,
    required int ordem,
    required String titulo,
    required String texto,
  })  : provaId = Value(provaId),
        imagem = Value(imagem),
        imagemBase64 = Value(imagemBase64),
        posicionamento = Value(posicionamento),
        ordem = Value(ordem),
        titulo = Value(titulo),
        texto = Value(texto);
  static Insertable<ContextoProva> custom({
    Expression<int>? id,
    Expression<int>? provaId,
    Expression<String>? imagem,
    Expression<String>? imagemBase64,
    Expression<int>? posicionamento,
    Expression<int>? ordem,
    Expression<String>? titulo,
    Expression<String>? texto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provaId != null) 'prova_id': provaId,
      if (imagem != null) 'imagem': imagem,
      if (imagemBase64 != null) 'imagem_base64': imagemBase64,
      if (posicionamento != null) 'posicionamento': posicionamento,
      if (ordem != null) 'ordem': ordem,
      if (titulo != null) 'titulo': titulo,
      if (texto != null) 'texto': texto,
    });
  }

  ContextosProvaDbCompanion copyWith(
      {Value<int>? id,
      Value<int>? provaId,
      Value<String>? imagem,
      Value<String>? imagemBase64,
      Value<PosicionamentoImagemEnum>? posicionamento,
      Value<int>? ordem,
      Value<String>? titulo,
      Value<String>? texto}) {
    return ContextosProvaDbCompanion(
      id: id ?? this.id,
      provaId: provaId ?? this.provaId,
      imagem: imagem ?? this.imagem,
      imagemBase64: imagemBase64 ?? this.imagemBase64,
      posicionamento: posicionamento ?? this.posicionamento,
      ordem: ordem ?? this.ordem,
      titulo: titulo ?? this.titulo,
      texto: texto ?? this.texto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (provaId.present) {
      map['prova_id'] = Variable<int>(provaId.value);
    }
    if (imagem.present) {
      map['imagem'] = Variable<String>(imagem.value);
    }
    if (imagemBase64.present) {
      map['imagem_base64'] = Variable<String>(imagemBase64.value);
    }
    if (posicionamento.present) {
      final converter = $ContextosProvaDbTable.$converter0;
      map['posicionamento'] =
          Variable<int>(converter.toSql(posicionamento.value));
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContextosProvaDbCompanion(')
          ..write('id: $id, ')
          ..write('provaId: $provaId, ')
          ..write('imagem: $imagem, ')
          ..write('imagemBase64: $imagemBase64, ')
          ..write('posicionamento: $posicionamento, ')
          ..write('ordem: $ordem, ')
          ..write('titulo: $titulo, ')
          ..write('texto: $texto')
          ..write(')'))
        .toString();
  }
}

class $ContextosProvaDbTable extends ContextosProvaDb
    with TableInfo<$ContextosProvaDbTable, ContextoProva> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContextosProvaDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _provaIdMeta = const VerificationMeta('provaId');
  @override
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _imagemMeta = const VerificationMeta('imagem');
  @override
  late final GeneratedColumn<String> imagem = GeneratedColumn<String>(
      'imagem', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _imagemBase64Meta =
      const VerificationMeta('imagemBase64');
  @override
  late final GeneratedColumn<String> imagemBase64 = GeneratedColumn<String>(
      'imagem_base64', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _posicionamentoMeta =
      const VerificationMeta('posicionamento');
  @override
  late final GeneratedColumnWithTypeConverter<PosicionamentoImagemEnum, int>
      posicionamento = GeneratedColumn<int>(
              'posicionamento', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<PosicionamentoImagemEnum>(
              $ContextosProvaDbTable.$converter0);
  final VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
      'titulo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
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
  VerificationContext validateIntegrity(Insertable<ContextoProva> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prova_id')) {
      context.handle(_provaIdMeta,
          provaId.isAcceptableOrUnknown(data['prova_id']!, _provaIdMeta));
    } else if (isInserting) {
      context.missing(_provaIdMeta);
    }
    if (data.containsKey('imagem')) {
      context.handle(_imagemMeta,
          imagem.isAcceptableOrUnknown(data['imagem']!, _imagemMeta));
    } else if (isInserting) {
      context.missing(_imagemMeta);
    }
    if (data.containsKey('imagem_base64')) {
      context.handle(
          _imagemBase64Meta,
          imagemBase64.isAcceptableOrUnknown(
              data['imagem_base64']!, _imagemBase64Meta));
    } else if (isInserting) {
      context.missing(_imagemBase64Meta);
    }
    context.handle(_posicionamentoMeta, const VerificationResult.success());
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('texto')) {
      context.handle(
          _textoMeta, texto.isAcceptableOrUnknown(data['texto']!, _textoMeta));
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContextoProva map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContextoProva(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      provaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}prova_id'])!,
      imagem: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}imagem'])!,
      imagemBase64: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}imagem_base64'])!,
      posicionamento: $ContextosProvaDbTable.$converter0.fromSql(
          attachedDatabase.options.types.read(
              DriftSqlType.int, data['${effectivePrefix}posicionamento'])!),
      ordem: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}ordem'])!,
      titulo: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}titulo'])!,
      texto: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}texto'])!,
    );
  }

  @override
  $ContextosProvaDbTable createAlias(String alias) {
    return $ContextosProvaDbTable(attachedDatabase, alias);
  }

  static TypeConverter<PosicionamentoImagemEnum, int> $converter0 =
      const EnumIndexConverter<PosicionamentoImagemEnum>(
          PosicionamentoImagemEnum.values);
}

class ArquivoVideoDb extends DataClass implements Insertable<ArquivoVideoDb> {
  final int id;
  final int questaoLegadoId;
  final String path;
  const ArquivoVideoDb(
      {required this.id, required this.questaoLegadoId, required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['questao_legado_id'] = Variable<int>(questaoLegadoId);
    map['path'] = Variable<String>(path);
    return map;
  }

  ArquivosVideoDbCompanion toCompanion(bool nullToAbsent) {
    return ArquivosVideoDbCompanion(
      id: Value(id),
      questaoLegadoId: Value(questaoLegadoId),
      path: Value(path),
    );
  }

  factory ArquivoVideoDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArquivoVideoDb(
      id: serializer.fromJson<int>(json['id']),
      questaoLegadoId: serializer.fromJson<int>(json['questaoLegadoId']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questaoLegadoId': serializer.toJson<int>(questaoLegadoId),
      'path': serializer.toJson<String>(path),
    };
  }

  ArquivoVideoDb copyWith({int? id, int? questaoLegadoId, String? path}) =>
      ArquivoVideoDb(
        id: id ?? this.id,
        questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
        path: path ?? this.path,
      );
  @override
  String toString() {
    return (StringBuffer('ArquivoVideoDb(')
          ..write('id: $id, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questaoLegadoId, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArquivoVideoDb &&
          other.id == this.id &&
          other.questaoLegadoId == this.questaoLegadoId &&
          other.path == this.path);
}

class ArquivosVideoDbCompanion extends UpdateCompanion<ArquivoVideoDb> {
  final Value<int> id;
  final Value<int> questaoLegadoId;
  final Value<String> path;
  const ArquivosVideoDbCompanion({
    this.id = const Value.absent(),
    this.questaoLegadoId = const Value.absent(),
    this.path = const Value.absent(),
  });
  ArquivosVideoDbCompanion.insert({
    this.id = const Value.absent(),
    required int questaoLegadoId,
    required String path,
  })  : questaoLegadoId = Value(questaoLegadoId),
        path = Value(path);
  static Insertable<ArquivoVideoDb> custom({
    Expression<int>? id,
    Expression<int>? questaoLegadoId,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (path != null) 'path': path,
    });
  }

  ArquivosVideoDbCompanion copyWith(
      {Value<int>? id, Value<int>? questaoLegadoId, Value<String>? path}) {
    return ArquivosVideoDbCompanion(
      id: id ?? this.id,
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      path: path ?? this.path,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArquivosVideoDbCompanion(')
          ..write('id: $id, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }
}

class $ArquivosVideoDbTable extends ArquivosVideoDb
    with TableInfo<$ArquivosVideoDbTable, ArquivoVideoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArquivosVideoDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
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
  VerificationContext validateIntegrity(Insertable<ArquivoVideoDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoLegadoIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArquivoVideoDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArquivoVideoDb(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
      path: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
    );
  }

  @override
  $ArquivosVideoDbTable createAlias(String alias) {
    return $ArquivosVideoDbTable(attachedDatabase, alias);
  }
}

class ArquivoAudioDb extends DataClass implements Insertable<ArquivoAudioDb> {
  final int id;
  final int questaoLegadoId;
  final String path;
  const ArquivoAudioDb(
      {required this.id, required this.questaoLegadoId, required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['questao_legado_id'] = Variable<int>(questaoLegadoId);
    map['path'] = Variable<String>(path);
    return map;
  }

  ArquivosAudioDbCompanion toCompanion(bool nullToAbsent) {
    return ArquivosAudioDbCompanion(
      id: Value(id),
      questaoLegadoId: Value(questaoLegadoId),
      path: Value(path),
    );
  }

  factory ArquivoAudioDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArquivoAudioDb(
      id: serializer.fromJson<int>(json['id']),
      questaoLegadoId: serializer.fromJson<int>(json['questaoLegadoId']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questaoLegadoId': serializer.toJson<int>(questaoLegadoId),
      'path': serializer.toJson<String>(path),
    };
  }

  ArquivoAudioDb copyWith({int? id, int? questaoLegadoId, String? path}) =>
      ArquivoAudioDb(
        id: id ?? this.id,
        questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
        path: path ?? this.path,
      );
  @override
  String toString() {
    return (StringBuffer('ArquivoAudioDb(')
          ..write('id: $id, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questaoLegadoId, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArquivoAudioDb &&
          other.id == this.id &&
          other.questaoLegadoId == this.questaoLegadoId &&
          other.path == this.path);
}

class ArquivosAudioDbCompanion extends UpdateCompanion<ArquivoAudioDb> {
  final Value<int> id;
  final Value<int> questaoLegadoId;
  final Value<String> path;
  const ArquivosAudioDbCompanion({
    this.id = const Value.absent(),
    this.questaoLegadoId = const Value.absent(),
    this.path = const Value.absent(),
  });
  ArquivosAudioDbCompanion.insert({
    this.id = const Value.absent(),
    required int questaoLegadoId,
    required String path,
  })  : questaoLegadoId = Value(questaoLegadoId),
        path = Value(path);
  static Insertable<ArquivoAudioDb> custom({
    Expression<int>? id,
    Expression<int>? questaoLegadoId,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (path != null) 'path': path,
    });
  }

  ArquivosAudioDbCompanion copyWith(
      {Value<int>? id, Value<int>? questaoLegadoId, Value<String>? path}) {
    return ArquivosAudioDbCompanion(
      id: id ?? this.id,
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      path: path ?? this.path,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArquivosAudioDbCompanion(')
          ..write('id: $id, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }
}

class $ArquivosAudioDbTable extends ArquivosAudioDb
    with TableInfo<$ArquivosAudioDbTable, ArquivoAudioDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArquivosAudioDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
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
  VerificationContext validateIntegrity(Insertable<ArquivoAudioDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoLegadoIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArquivoAudioDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArquivoAudioDb(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
      path: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
    );
  }

  @override
  $ArquivosAudioDbTable createAlias(String alias) {
    return $ArquivosAudioDbTable(attachedDatabase, alias);
  }
}

class DownloadProvaDb extends DataClass implements Insertable<DownloadProvaDb> {
  final int id;
  final int provaId;
  final int? questaoLegadoId;
  final int? ordem;
  final EnumDownloadTipo tipo;
  final EnumDownloadStatus downloadStatus;
  final DateTime dataHoraInicio;
  final DateTime? dataHoraFim;
  const DownloadProvaDb(
      {required this.id,
      required this.provaId,
      this.questaoLegadoId,
      this.ordem,
      required this.tipo,
      required this.downloadStatus,
      required this.dataHoraInicio,
      this.dataHoraFim});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prova_id'] = Variable<int>(provaId);
    if (!nullToAbsent || questaoLegadoId != null) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId);
    }
    if (!nullToAbsent || ordem != null) {
      map['ordem'] = Variable<int>(ordem);
    }
    {
      final converter = $DownloadProvasDbTable.$converter0;
      map['tipo'] = Variable<int>(converter.toSql(tipo));
    }
    {
      final converter = $DownloadProvasDbTable.$converter1;
      map['download_status'] = Variable<int>(converter.toSql(downloadStatus));
    }
    map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio);
    if (!nullToAbsent || dataHoraFim != null) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim);
    }
    return map;
  }

  DownloadProvasDbCompanion toCompanion(bool nullToAbsent) {
    return DownloadProvasDbCompanion(
      id: Value(id),
      provaId: Value(provaId),
      questaoLegadoId: questaoLegadoId == null && nullToAbsent
          ? const Value.absent()
          : Value(questaoLegadoId),
      ordem:
          ordem == null && nullToAbsent ? const Value.absent() : Value(ordem),
      tipo: Value(tipo),
      downloadStatus: Value(downloadStatus),
      dataHoraInicio: Value(dataHoraInicio),
      dataHoraFim: dataHoraFim == null && nullToAbsent
          ? const Value.absent()
          : Value(dataHoraFim),
    );
  }

  factory DownloadProvaDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadProvaDb(
      id: serializer.fromJson<int>(json['id']),
      provaId: serializer.fromJson<int>(json['provaId']),
      questaoLegadoId: serializer.fromJson<int?>(json['questaoLegadoId']),
      ordem: serializer.fromJson<int?>(json['ordem']),
      tipo: serializer.fromJson<EnumDownloadTipo>(json['tipo']),
      downloadStatus:
          serializer.fromJson<EnumDownloadStatus>(json['downloadStatus']),
      dataHoraInicio: serializer.fromJson<DateTime>(json['dataHoraInicio']),
      dataHoraFim: serializer.fromJson<DateTime?>(json['dataHoraFim']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'provaId': serializer.toJson<int>(provaId),
      'questaoLegadoId': serializer.toJson<int?>(questaoLegadoId),
      'ordem': serializer.toJson<int?>(ordem),
      'tipo': serializer.toJson<EnumDownloadTipo>(tipo),
      'downloadStatus': serializer.toJson<EnumDownloadStatus>(downloadStatus),
      'dataHoraInicio': serializer.toJson<DateTime>(dataHoraInicio),
      'dataHoraFim': serializer.toJson<DateTime?>(dataHoraFim),
    };
  }

  DownloadProvaDb copyWith(
          {int? id,
          int? provaId,
          Value<int?> questaoLegadoId = const Value.absent(),
          Value<int?> ordem = const Value.absent(),
          EnumDownloadTipo? tipo,
          EnumDownloadStatus? downloadStatus,
          DateTime? dataHoraInicio,
          Value<DateTime?> dataHoraFim = const Value.absent()}) =>
      DownloadProvaDb(
        id: id ?? this.id,
        provaId: provaId ?? this.provaId,
        questaoLegadoId: questaoLegadoId.present
            ? questaoLegadoId.value
            : this.questaoLegadoId,
        ordem: ordem.present ? ordem.value : this.ordem,
        tipo: tipo ?? this.tipo,
        downloadStatus: downloadStatus ?? this.downloadStatus,
        dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
        dataHoraFim: dataHoraFim.present ? dataHoraFim.value : this.dataHoraFim,
      );
  @override
  String toString() {
    return (StringBuffer('DownloadProvaDb(')
          ..write('id: $id, ')
          ..write('provaId: $provaId, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('ordem: $ordem, ')
          ..write('tipo: $tipo, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, provaId, questaoLegadoId, ordem, tipo,
      downloadStatus, dataHoraInicio, dataHoraFim);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadProvaDb &&
          other.id == this.id &&
          other.provaId == this.provaId &&
          other.questaoLegadoId == this.questaoLegadoId &&
          other.ordem == this.ordem &&
          other.tipo == this.tipo &&
          other.downloadStatus == this.downloadStatus &&
          other.dataHoraInicio == this.dataHoraInicio &&
          other.dataHoraFim == this.dataHoraFim);
}

class DownloadProvasDbCompanion extends UpdateCompanion<DownloadProvaDb> {
  final Value<int> id;
  final Value<int> provaId;
  final Value<int?> questaoLegadoId;
  final Value<int?> ordem;
  final Value<EnumDownloadTipo> tipo;
  final Value<EnumDownloadStatus> downloadStatus;
  final Value<DateTime> dataHoraInicio;
  final Value<DateTime?> dataHoraFim;
  const DownloadProvasDbCompanion({
    this.id = const Value.absent(),
    this.provaId = const Value.absent(),
    this.questaoLegadoId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.tipo = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.dataHoraInicio = const Value.absent(),
    this.dataHoraFim = const Value.absent(),
  });
  DownloadProvasDbCompanion.insert({
    required int id,
    required int provaId,
    this.questaoLegadoId = const Value.absent(),
    this.ordem = const Value.absent(),
    required EnumDownloadTipo tipo,
    required EnumDownloadStatus downloadStatus,
    required DateTime dataHoraInicio,
    this.dataHoraFim = const Value.absent(),
  })  : id = Value(id),
        provaId = Value(provaId),
        tipo = Value(tipo),
        downloadStatus = Value(downloadStatus),
        dataHoraInicio = Value(dataHoraInicio);
  static Insertable<DownloadProvaDb> custom({
    Expression<int>? id,
    Expression<int>? provaId,
    Expression<int>? questaoLegadoId,
    Expression<int>? ordem,
    Expression<int>? tipo,
    Expression<int>? downloadStatus,
    Expression<DateTime>? dataHoraInicio,
    Expression<DateTime>? dataHoraFim,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provaId != null) 'prova_id': provaId,
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (ordem != null) 'ordem': ordem,
      if (tipo != null) 'tipo': tipo,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (dataHoraInicio != null) 'data_hora_inicio': dataHoraInicio,
      if (dataHoraFim != null) 'data_hora_fim': dataHoraFim,
    });
  }

  DownloadProvasDbCompanion copyWith(
      {Value<int>? id,
      Value<int>? provaId,
      Value<int?>? questaoLegadoId,
      Value<int?>? ordem,
      Value<EnumDownloadTipo>? tipo,
      Value<EnumDownloadStatus>? downloadStatus,
      Value<DateTime>? dataHoraInicio,
      Value<DateTime?>? dataHoraFim}) {
    return DownloadProvasDbCompanion(
      id: id ?? this.id,
      provaId: provaId ?? this.provaId,
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      dataHoraFim: dataHoraFim ?? this.dataHoraFim,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (provaId.present) {
      map['prova_id'] = Variable<int>(provaId.value);
    }
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (tipo.present) {
      final converter = $DownloadProvasDbTable.$converter0;
      map['tipo'] = Variable<int>(converter.toSql(tipo.value));
    }
    if (downloadStatus.present) {
      final converter = $DownloadProvasDbTable.$converter1;
      map['download_status'] =
          Variable<int>(converter.toSql(downloadStatus.value));
    }
    if (dataHoraInicio.present) {
      map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio.value);
    }
    if (dataHoraFim.present) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadProvasDbCompanion(')
          ..write('id: $id, ')
          ..write('provaId: $provaId, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('ordem: $ordem, ')
          ..write('tipo: $tipo, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim')
          ..write(')'))
        .toString();
  }
}

class $DownloadProvasDbTable extends DownloadProvasDb
    with TableInfo<$DownloadProvasDbTable, DownloadProvaDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadProvasDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _provaIdMeta = const VerificationMeta('provaId');
  @override
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumnWithTypeConverter<EnumDownloadTipo, int> tipo =
      GeneratedColumn<int>('tipo', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EnumDownloadTipo>($DownloadProvasDbTable.$converter0);
  final VerificationMeta _downloadStatusMeta =
      const VerificationMeta('downloadStatus');
  @override
  late final GeneratedColumnWithTypeConverter<EnumDownloadStatus, int>
      downloadStatus = GeneratedColumn<int>(
              'download_status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EnumDownloadStatus>(
              $DownloadProvasDbTable.$converter1);
  final VerificationMeta _dataHoraInicioMeta =
      const VerificationMeta('dataHoraInicio');
  @override
  late final GeneratedColumn<DateTime> dataHoraInicio =
      GeneratedColumn<DateTime>('data_hora_inicio', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _dataHoraFimMeta =
      const VerificationMeta('dataHoraFim');
  @override
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
  VerificationContext validateIntegrity(Insertable<DownloadProvaDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('prova_id')) {
      context.handle(_provaIdMeta,
          provaId.isAcceptableOrUnknown(data['prova_id']!, _provaIdMeta));
    } else if (isInserting) {
      context.missing(_provaIdMeta);
    }
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    }
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    context.handle(_downloadStatusMeta, const VerificationResult.success());
    if (data.containsKey('data_hora_inicio')) {
      context.handle(
          _dataHoraInicioMeta,
          dataHoraInicio.isAcceptableOrUnknown(
              data['data_hora_inicio']!, _dataHoraInicioMeta));
    } else if (isInserting) {
      context.missing(_dataHoraInicioMeta);
    }
    if (data.containsKey('data_hora_fim')) {
      context.handle(
          _dataHoraFimMeta,
          dataHoraFim.isAcceptableOrUnknown(
              data['data_hora_fim']!, _dataHoraFimMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, provaId};
  @override
  DownloadProvaDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadProvaDb(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      provaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}prova_id'])!,
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id']),
      ordem: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}ordem']),
      tipo: $DownloadProvasDbTable.$converter0.fromSql(attachedDatabase
          .options.types
          .read(DriftSqlType.int, data['${effectivePrefix}tipo'])!),
      downloadStatus: $DownloadProvasDbTable.$converter1.fromSql(
          attachedDatabase.options.types.read(
              DriftSqlType.int, data['${effectivePrefix}download_status'])!),
      dataHoraInicio: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_hora_inicio'])!,
      dataHoraFim: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_hora_fim']),
    );
  }

  @override
  $DownloadProvasDbTable createAlias(String alias) {
    return $DownloadProvasDbTable(attachedDatabase, alias);
  }

  static TypeConverter<EnumDownloadTipo, int> $converter0 =
      const EnumIndexConverter<EnumDownloadTipo>(EnumDownloadTipo.values);
  static TypeConverter<EnumDownloadStatus, int> $converter1 =
      const EnumIndexConverter<EnumDownloadStatus>(EnumDownloadStatus.values);
}

class ProvaAlunoTableCompanion extends UpdateCompanion<ProvaAluno> {
  final Value<String> codigoEOL;
  final Value<int> provaId;
  const ProvaAlunoTableCompanion({
    this.codigoEOL = const Value.absent(),
    this.provaId = const Value.absent(),
  });
  ProvaAlunoTableCompanion.insert({
    required String codigoEOL,
    required int provaId,
  })  : codigoEOL = Value(codigoEOL),
        provaId = Value(provaId);
  static Insertable<ProvaAluno> custom({
    Expression<String>? codigoEOL,
    Expression<int>? provaId,
  }) {
    return RawValuesInsertable({
      if (codigoEOL != null) 'codigo_e_o_l': codigoEOL,
      if (provaId != null) 'prova_id': provaId,
    });
  }

  ProvaAlunoTableCompanion copyWith(
      {Value<String>? codigoEOL, Value<int>? provaId}) {
    return ProvaAlunoTableCompanion(
      codigoEOL: codigoEOL ?? this.codigoEOL,
      provaId: provaId ?? this.provaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigoEOL.present) {
      map['codigo_e_o_l'] = Variable<String>(codigoEOL.value);
    }
    if (provaId.present) {
      map['prova_id'] = Variable<int>(provaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvaAlunoTableCompanion(')
          ..write('codigoEOL: $codigoEOL, ')
          ..write('provaId: $provaId')
          ..write(')'))
        .toString();
  }
}

class $ProvaAlunoTableTable extends ProvaAlunoTable
    with TableInfo<$ProvaAlunoTableTable, ProvaAluno> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvaAlunoTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _codigoEOLMeta = const VerificationMeta('codigoEOL');
  @override
  late final GeneratedColumn<String> codigoEOL = GeneratedColumn<String>(
      'codigo_e_o_l', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _provaIdMeta = const VerificationMeta('provaId');
  @override
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
  VerificationContext validateIntegrity(Insertable<ProvaAluno> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo_e_o_l')) {
      context.handle(
          _codigoEOLMeta,
          codigoEOL.isAcceptableOrUnknown(
              data['codigo_e_o_l']!, _codigoEOLMeta));
    } else if (isInserting) {
      context.missing(_codigoEOLMeta);
    }
    if (data.containsKey('prova_id')) {
      context.handle(_provaIdMeta,
          provaId.isAcceptableOrUnknown(data['prova_id']!, _provaIdMeta));
    } else if (isInserting) {
      context.missing(_provaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigoEOL, provaId};
  @override
  ProvaAluno map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProvaAluno(
      codigoEOL: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_e_o_l'])!,
      provaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}prova_id'])!,
    );
  }

  @override
  $ProvaAlunoTableTable createAlias(String alias) {
    return $ProvaAlunoTableTable(attachedDatabase, alias);
  }
}

class ProvaCadernoTableCompanion extends UpdateCompanion<ProvaCaderno> {
  final Value<int> questaoId;
  final Value<int> questaoLegadoId;
  final Value<int> provaId;
  final Value<String> caderno;
  final Value<int> ordem;
  const ProvaCadernoTableCompanion({
    this.questaoId = const Value.absent(),
    this.questaoLegadoId = const Value.absent(),
    this.provaId = const Value.absent(),
    this.caderno = const Value.absent(),
    this.ordem = const Value.absent(),
  });
  ProvaCadernoTableCompanion.insert({
    required int questaoId,
    required int questaoLegadoId,
    required int provaId,
    required String caderno,
    required int ordem,
  })  : questaoId = Value(questaoId),
        questaoLegadoId = Value(questaoLegadoId),
        provaId = Value(provaId),
        caderno = Value(caderno),
        ordem = Value(ordem);
  static Insertable<ProvaCaderno> custom({
    Expression<int>? questaoId,
    Expression<int>? questaoLegadoId,
    Expression<int>? provaId,
    Expression<String>? caderno,
    Expression<int>? ordem,
  }) {
    return RawValuesInsertable({
      if (questaoId != null) 'questao_id': questaoId,
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (provaId != null) 'prova_id': provaId,
      if (caderno != null) 'caderno': caderno,
      if (ordem != null) 'ordem': ordem,
    });
  }

  ProvaCadernoTableCompanion copyWith(
      {Value<int>? questaoId,
      Value<int>? questaoLegadoId,
      Value<int>? provaId,
      Value<String>? caderno,
      Value<int>? ordem}) {
    return ProvaCadernoTableCompanion(
      questaoId: questaoId ?? this.questaoId,
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      provaId: provaId ?? this.provaId,
      caderno: caderno ?? this.caderno,
      ordem: ordem ?? this.ordem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questaoId.present) {
      map['questao_id'] = Variable<int>(questaoId.value);
    }
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (provaId.present) {
      map['prova_id'] = Variable<int>(provaId.value);
    }
    if (caderno.present) {
      map['caderno'] = Variable<String>(caderno.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvaCadernoTableCompanion(')
          ..write('questaoId: $questaoId, ')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('provaId: $provaId, ')
          ..write('caderno: $caderno, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }
}

class $ProvaCadernoTableTable extends ProvaCadernoTable
    with TableInfo<$ProvaCadernoTableTable, ProvaCaderno> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvaCadernoTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _questaoIdMeta = const VerificationMeta('questaoId');
  @override
  late final GeneratedColumn<int> questaoId = GeneratedColumn<int>(
      'questao_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _provaIdMeta = const VerificationMeta('provaId');
  @override
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _cadernoMeta = const VerificationMeta('caderno');
  @override
  late final GeneratedColumn<String> caderno = GeneratedColumn<String>(
      'caderno', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
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
  VerificationContext validateIntegrity(Insertable<ProvaCaderno> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('questao_id')) {
      context.handle(_questaoIdMeta,
          questaoId.isAcceptableOrUnknown(data['questao_id']!, _questaoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoIdMeta);
    }
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoLegadoIdMeta);
    }
    if (data.containsKey('prova_id')) {
      context.handle(_provaIdMeta,
          provaId.isAcceptableOrUnknown(data['prova_id']!, _provaIdMeta));
    } else if (isInserting) {
      context.missing(_provaIdMeta);
    }
    if (data.containsKey('caderno')) {
      context.handle(_cadernoMeta,
          caderno.isAcceptableOrUnknown(data['caderno']!, _cadernoMeta));
    } else if (isInserting) {
      context.missing(_cadernoMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId, provaId, caderno};
  @override
  ProvaCaderno map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProvaCaderno(
      provaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}prova_id'])!,
      caderno: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}caderno'])!,
      ordem: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}ordem'])!,
      questaoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_id'])!,
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
    );
  }

  @override
  $ProvaCadernoTableTable createAlias(String alias) {
    return $ProvaCadernoTableTable(attachedDatabase, alias);
  }
}

class QuestaoArquivoTableCompanion extends UpdateCompanion<QuestaoArquivo> {
  final Value<int> questaoLegadoId;
  final Value<int> arquivoLegadoId;
  const QuestaoArquivoTableCompanion({
    this.questaoLegadoId = const Value.absent(),
    this.arquivoLegadoId = const Value.absent(),
  });
  QuestaoArquivoTableCompanion.insert({
    required int questaoLegadoId,
    required int arquivoLegadoId,
  })  : questaoLegadoId = Value(questaoLegadoId),
        arquivoLegadoId = Value(arquivoLegadoId);
  static Insertable<QuestaoArquivo> custom({
    Expression<int>? questaoLegadoId,
    Expression<int>? arquivoLegadoId,
  }) {
    return RawValuesInsertable({
      if (questaoLegadoId != null) 'questao_legado_id': questaoLegadoId,
      if (arquivoLegadoId != null) 'arquivo_legado_id': arquivoLegadoId,
    });
  }

  QuestaoArquivoTableCompanion copyWith(
      {Value<int>? questaoLegadoId, Value<int>? arquivoLegadoId}) {
    return QuestaoArquivoTableCompanion(
      questaoLegadoId: questaoLegadoId ?? this.questaoLegadoId,
      arquivoLegadoId: arquivoLegadoId ?? this.arquivoLegadoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questaoLegadoId.present) {
      map['questao_legado_id'] = Variable<int>(questaoLegadoId.value);
    }
    if (arquivoLegadoId.present) {
      map['arquivo_legado_id'] = Variable<int>(arquivoLegadoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestaoArquivoTableCompanion(')
          ..write('questaoLegadoId: $questaoLegadoId, ')
          ..write('arquivoLegadoId: $arquivoLegadoId')
          ..write(')'))
        .toString();
  }
}

class $QuestaoArquivoTableTable extends QuestaoArquivoTable
    with TableInfo<$QuestaoArquivoTableTable, QuestaoArquivo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestaoArquivoTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _questaoLegadoIdMeta =
      const VerificationMeta('questaoLegadoId');
  @override
  late final GeneratedColumn<int> questaoLegadoId = GeneratedColumn<int>(
      'questao_legado_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _arquivoLegadoIdMeta =
      const VerificationMeta('arquivoLegadoId');
  @override
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
  VerificationContext validateIntegrity(Insertable<QuestaoArquivo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('questao_legado_id')) {
      context.handle(
          _questaoLegadoIdMeta,
          questaoLegadoId.isAcceptableOrUnknown(
              data['questao_legado_id']!, _questaoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoLegadoIdMeta);
    }
    if (data.containsKey('arquivo_legado_id')) {
      context.handle(
          _arquivoLegadoIdMeta,
          arquivoLegadoId.isAcceptableOrUnknown(
              data['arquivo_legado_id']!, _arquivoLegadoIdMeta));
    } else if (isInserting) {
      context.missing(_arquivoLegadoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questaoLegadoId, arquivoLegadoId};
  @override
  QuestaoArquivo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestaoArquivo(
      questaoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_legado_id'])!,
      arquivoLegadoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}arquivo_legado_id'])!,
    );
  }

  @override
  $QuestaoArquivoTableTable createAlias(String alias) {
    return $QuestaoArquivoTableTable(attachedDatabase, alias);
  }
}

class JobsTableCompanion extends UpdateCompanion<Job> {
  final Value<String> id;
  final Value<String> nome;
  final Value<EnumJobStatus?> statusUltimaExecucao;
  final Value<DateTime?> ultimaExecucao;
  final Value<int> intervalo;
  const JobsTableCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.statusUltimaExecucao = const Value.absent(),
    this.ultimaExecucao = const Value.absent(),
    this.intervalo = const Value.absent(),
  });
  JobsTableCompanion.insert({
    required String id,
    required String nome,
    this.statusUltimaExecucao = const Value.absent(),
    this.ultimaExecucao = const Value.absent(),
    required int intervalo,
  })  : id = Value(id),
        nome = Value(nome),
        intervalo = Value(intervalo);
  static Insertable<Job> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<int>? statusUltimaExecucao,
    Expression<DateTime>? ultimaExecucao,
    Expression<int>? intervalo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (statusUltimaExecucao != null)
        'status_ultima_execucao': statusUltimaExecucao,
      if (ultimaExecucao != null) 'ultima_execucao': ultimaExecucao,
      if (intervalo != null) 'intervalo': intervalo,
    });
  }

  JobsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<EnumJobStatus?>? statusUltimaExecucao,
      Value<DateTime?>? ultimaExecucao,
      Value<int>? intervalo}) {
    return JobsTableCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      statusUltimaExecucao: statusUltimaExecucao ?? this.statusUltimaExecucao,
      ultimaExecucao: ultimaExecucao ?? this.ultimaExecucao,
      intervalo: intervalo ?? this.intervalo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (statusUltimaExecucao.present) {
      final converter = $JobsTableTable.$converter0n;
      map['status_ultima_execucao'] =
          Variable<int>(converter.toSql(statusUltimaExecucao.value));
    }
    if (ultimaExecucao.present) {
      map['ultima_execucao'] = Variable<DateTime>(ultimaExecucao.value);
    }
    if (intervalo.present) {
      map['intervalo'] = Variable<int>(intervalo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobsTableCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('statusUltimaExecucao: $statusUltimaExecucao, ')
          ..write('ultimaExecucao: $ultimaExecucao, ')
          ..write('intervalo: $intervalo')
          ..write(')'))
        .toString();
  }
}

class $JobsTableTable extends JobsTable with TableInfo<$JobsTableTable, Job> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobsTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _statusUltimaExecucaoMeta =
      const VerificationMeta('statusUltimaExecucao');
  @override
  late final GeneratedColumnWithTypeConverter<EnumJobStatus?, int>
      statusUltimaExecucao = GeneratedColumn<int>(
              'status_ultima_execucao', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<EnumJobStatus?>($JobsTableTable.$converter0n);
  final VerificationMeta _ultimaExecucaoMeta =
      const VerificationMeta('ultimaExecucao');
  @override
  late final GeneratedColumn<DateTime> ultimaExecucao =
      GeneratedColumn<DateTime>('ultima_execucao', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _intervaloMeta = const VerificationMeta('intervalo');
  @override
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
  VerificationContext validateIntegrity(Insertable<Job> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    context.handle(
        _statusUltimaExecucaoMeta, const VerificationResult.success());
    if (data.containsKey('ultima_execucao')) {
      context.handle(
          _ultimaExecucaoMeta,
          ultimaExecucao.isAcceptableOrUnknown(
              data['ultima_execucao']!, _ultimaExecucaoMeta));
    }
    if (data.containsKey('intervalo')) {
      context.handle(_intervaloMeta,
          intervalo.isAcceptableOrUnknown(data['intervalo']!, _intervaloMeta));
    } else if (isInserting) {
      context.missing(_intervaloMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Job map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Job(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      statusUltimaExecucao: $JobsTableTable.$converter0n.fromSql(
          attachedDatabase.options.types.read(DriftSqlType.int,
              data['${effectivePrefix}status_ultima_execucao'])),
      ultimaExecucao: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}ultima_execucao']),
      intervalo: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}intervalo'])!,
    );
  }

  @override
  $JobsTableTable createAlias(String alias) {
    return $JobsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<EnumJobStatus, int> $converter0 =
      const EnumIndexConverter<EnumJobStatus>(EnumJobStatus.values);
  static TypeConverter<EnumJobStatus?, int?> $converter0n =
      NullAwareTypeConverter.wrap($converter0);
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $ProvasDbTable provasDb = $ProvasDbTable(this);
  late final $QuestoesDbTable questoesDb = $QuestoesDbTable(this);
  late final $AlternativasDbTable alternativasDb = $AlternativasDbTable(this);
  late final $ArquivosDbTable arquivosDb = $ArquivosDbTable(this);
  late final $ContextosProvaDbTable contextosProvaDb =
      $ContextosProvaDbTable(this);
  late final $ArquivosVideoDbTable arquivosVideoDb =
      $ArquivosVideoDbTable(this);
  late final $ArquivosAudioDbTable arquivosAudioDb =
      $ArquivosAudioDbTable(this);
  late final $DownloadProvasDbTable downloadProvasDb =
      $DownloadProvasDbTable(this);
  late final $ProvaAlunoTableTable provaAlunoTable =
      $ProvaAlunoTableTable(this);
  late final $ProvaCadernoTableTable provaCadernoTable =
      $ProvaCadernoTableTable(this);
  late final $QuestaoArquivoTableTable questaoArquivoTable =
      $QuestaoArquivoTableTable(this);
  late final $JobsTableTable jobsTable = $JobsTableTable(this);
  late final ArquivosVideosDao arquivosVideosDao =
      ArquivosVideosDao(this as AppDatabase);
  late final ArquivosAudioDao arquivosAudioDao =
      ArquivosAudioDao(this as AppDatabase);
  late final DownloadProvaDao downloadProvaDao =
      DownloadProvaDao(this as AppDatabase);
  late final QuestaoDao questaoDao = QuestaoDao(this as AppDatabase);
  late final AlternativaDao alternativaDao =
      AlternativaDao(this as AppDatabase);
  late final ArquivoDao arquivoDao = ArquivoDao(this as AppDatabase);
  late final ContextoProvaDao contextoProvaDao =
      ContextoProvaDao(this as AppDatabase);
  late final ProvaDao provaDao = ProvaDao(this as AppDatabase);
  late final ProvaAlunoDao provaAlunoDao = ProvaAlunoDao(this as AppDatabase);
  late final ProvaCadernoDao provaCadernoDao =
      ProvaCadernoDao(this as AppDatabase);
  late final QuestaoArquivoDao questaoArquivoDao =
      QuestaoArquivoDao(this as AppDatabase);
  late final JobDao jobDao = JobDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
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
}
