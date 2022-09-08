// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respostas.database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RespostaProvaTableCompanion extends UpdateCompanion<RespostaProva> {
  final Value<String> codigoEOL;
  final Value<int> questaoId;
  final Value<int> provaId;
  final Value<String> dispositivoId;
  final Value<int?> alternativaId;
  final Value<String?> resposta;
  final Value<int> tempoRespostaAluno;
  final Value<DateTime?> dataHoraResposta;
  final Value<bool> sincronizado;
  const RespostaProvaTableCompanion({
    this.codigoEOL = const Value.absent(),
    this.questaoId = const Value.absent(),
    this.provaId = const Value.absent(),
    this.dispositivoId = const Value.absent(),
    this.alternativaId = const Value.absent(),
    this.resposta = const Value.absent(),
    this.tempoRespostaAluno = const Value.absent(),
    this.dataHoraResposta = const Value.absent(),
    this.sincronizado = const Value.absent(),
  });
  RespostaProvaTableCompanion.insert({
    required String codigoEOL,
    required int questaoId,
    required int provaId,
    required String dispositivoId,
    this.alternativaId = const Value.absent(),
    this.resposta = const Value.absent(),
    required int tempoRespostaAluno,
    this.dataHoraResposta = const Value.absent(),
    required bool sincronizado,
  })  : codigoEOL = Value(codigoEOL),
        questaoId = Value(questaoId),
        provaId = Value(provaId),
        dispositivoId = Value(dispositivoId),
        tempoRespostaAluno = Value(tempoRespostaAluno),
        sincronizado = Value(sincronizado);
  static Insertable<RespostaProva> custom({
    Expression<String>? codigoEOL,
    Expression<int>? questaoId,
    Expression<int>? provaId,
    Expression<String>? dispositivoId,
    Expression<int>? alternativaId,
    Expression<String>? resposta,
    Expression<int>? tempoRespostaAluno,
    Expression<DateTime>? dataHoraResposta,
    Expression<bool>? sincronizado,
  }) {
    return RawValuesInsertable({
      if (codigoEOL != null) 'codigo_e_o_l': codigoEOL,
      if (questaoId != null) 'questao_id': questaoId,
      if (provaId != null) 'prova_id': provaId,
      if (dispositivoId != null) 'dispositivo_id': dispositivoId,
      if (alternativaId != null) 'alternativa_id': alternativaId,
      if (resposta != null) 'resposta': resposta,
      if (tempoRespostaAluno != null)
        'tempo_resposta_aluno': tempoRespostaAluno,
      if (dataHoraResposta != null) 'data_hora_resposta': dataHoraResposta,
      if (sincronizado != null) 'sincronizado': sincronizado,
    });
  }

  RespostaProvaTableCompanion copyWith(
      {Value<String>? codigoEOL,
      Value<int>? questaoId,
      Value<int>? provaId,
      Value<String>? dispositivoId,
      Value<int?>? alternativaId,
      Value<String?>? resposta,
      Value<int>? tempoRespostaAluno,
      Value<DateTime?>? dataHoraResposta,
      Value<bool>? sincronizado}) {
    return RespostaProvaTableCompanion(
      codigoEOL: codigoEOL ?? this.codigoEOL,
      questaoId: questaoId ?? this.questaoId,
      provaId: provaId ?? this.provaId,
      dispositivoId: dispositivoId ?? this.dispositivoId,
      alternativaId: alternativaId ?? this.alternativaId,
      resposta: resposta ?? this.resposta,
      tempoRespostaAluno: tempoRespostaAluno ?? this.tempoRespostaAluno,
      dataHoraResposta: dataHoraResposta ?? this.dataHoraResposta,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigoEOL.present) {
      map['codigo_e_o_l'] = Variable<String>(codigoEOL.value);
    }
    if (questaoId.present) {
      map['questao_id'] = Variable<int>(questaoId.value);
    }
    if (provaId.present) {
      map['prova_id'] = Variable<int>(provaId.value);
    }
    if (dispositivoId.present) {
      map['dispositivo_id'] = Variable<String>(dispositivoId.value);
    }
    if (alternativaId.present) {
      map['alternativa_id'] = Variable<int>(alternativaId.value);
    }
    if (resposta.present) {
      map['resposta'] = Variable<String>(resposta.value);
    }
    if (tempoRespostaAluno.present) {
      map['tempo_resposta_aluno'] = Variable<int>(tempoRespostaAluno.value);
    }
    if (dataHoraResposta.present) {
      map['data_hora_resposta'] = Variable<DateTime>(dataHoraResposta.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespostaProvaTableCompanion(')
          ..write('codigoEOL: $codigoEOL, ')
          ..write('questaoId: $questaoId, ')
          ..write('provaId: $provaId, ')
          ..write('dispositivoId: $dispositivoId, ')
          ..write('alternativaId: $alternativaId, ')
          ..write('resposta: $resposta, ')
          ..write('tempoRespostaAluno: $tempoRespostaAluno, ')
          ..write('dataHoraResposta: $dataHoraResposta, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }
}

class $RespostaProvaTableTable extends RespostaProvaTable
    with TableInfo<$RespostaProvaTableTable, RespostaProva> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespostaProvaTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _codigoEOLMeta = const VerificationMeta('codigoEOL');
  @override
  late final GeneratedColumn<String> codigoEOL = GeneratedColumn<String>(
      'codigo_e_o_l', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _questaoIdMeta = const VerificationMeta('questaoId');
  @override
  late final GeneratedColumn<int> questaoId = GeneratedColumn<int>(
      'questao_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _provaIdMeta = const VerificationMeta('provaId');
  @override
  late final GeneratedColumn<int> provaId = GeneratedColumn<int>(
      'prova_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _dispositivoIdMeta =
      const VerificationMeta('dispositivoId');
  @override
  late final GeneratedColumn<String> dispositivoId = GeneratedColumn<String>(
      'dispositivo_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _alternativaIdMeta =
      const VerificationMeta('alternativaId');
  @override
  late final GeneratedColumn<int> alternativaId = GeneratedColumn<int>(
      'alternativa_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _respostaMeta = const VerificationMeta('resposta');
  @override
  late final GeneratedColumn<String> resposta = GeneratedColumn<String>(
      'resposta', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _tempoRespostaAlunoMeta =
      const VerificationMeta('tempoRespostaAluno');
  @override
  late final GeneratedColumn<int> tempoRespostaAluno = GeneratedColumn<int>(
      'tempo_resposta_aluno', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _dataHoraRespostaMeta =
      const VerificationMeta('dataHoraResposta');
  @override
  late final GeneratedColumn<DateTime> dataHoraResposta =
      GeneratedColumn<DateTime>('data_hora_resposta', aliasedName, true,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  final VerificationMeta _sincronizadoMeta =
      const VerificationMeta('sincronizado');
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
      'sincronizado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (sincronizado IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [
        codigoEOL,
        questaoId,
        provaId,
        dispositivoId,
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
  VerificationContext validateIntegrity(Insertable<RespostaProva> instance,
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
    if (data.containsKey('questao_id')) {
      context.handle(_questaoIdMeta,
          questaoId.isAcceptableOrUnknown(data['questao_id']!, _questaoIdMeta));
    } else if (isInserting) {
      context.missing(_questaoIdMeta);
    }
    if (data.containsKey('prova_id')) {
      context.handle(_provaIdMeta,
          provaId.isAcceptableOrUnknown(data['prova_id']!, _provaIdMeta));
    } else if (isInserting) {
      context.missing(_provaIdMeta);
    }
    if (data.containsKey('dispositivo_id')) {
      context.handle(
          _dispositivoIdMeta,
          dispositivoId.isAcceptableOrUnknown(
              data['dispositivo_id']!, _dispositivoIdMeta));
    } else if (isInserting) {
      context.missing(_dispositivoIdMeta);
    }
    if (data.containsKey('alternativa_id')) {
      context.handle(
          _alternativaIdMeta,
          alternativaId.isAcceptableOrUnknown(
              data['alternativa_id']!, _alternativaIdMeta));
    }
    if (data.containsKey('resposta')) {
      context.handle(_respostaMeta,
          resposta.isAcceptableOrUnknown(data['resposta']!, _respostaMeta));
    }
    if (data.containsKey('tempo_resposta_aluno')) {
      context.handle(
          _tempoRespostaAlunoMeta,
          tempoRespostaAluno.isAcceptableOrUnknown(
              data['tempo_resposta_aluno']!, _tempoRespostaAlunoMeta));
    } else if (isInserting) {
      context.missing(_tempoRespostaAlunoMeta);
    }
    if (data.containsKey('data_hora_resposta')) {
      context.handle(
          _dataHoraRespostaMeta,
          dataHoraResposta.isAcceptableOrUnknown(
              data['data_hora_resposta']!, _dataHoraRespostaMeta));
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
          _sincronizadoMeta,
          sincronizado.isAcceptableOrUnknown(
              data['sincronizado']!, _sincronizadoMeta));
    } else if (isInserting) {
      context.missing(_sincronizadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigoEOL, provaId, questaoId};
  @override
  RespostaProva map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespostaProva(
      codigoEOL: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_e_o_l'])!,
      dispositivoId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}dispositivo_id'])!,
      provaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}prova_id'])!,
      questaoId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}questao_id'])!,
      alternativaId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}alternativa_id']),
      resposta: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}resposta']),
      sincronizado: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizado'])!,
      dataHoraResposta: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_hora_resposta']),
      tempoRespostaAluno: attachedDatabase.options.types.read(
          DriftSqlType.int, data['${effectivePrefix}tempo_resposta_aluno'])!,
    );
  }

  @override
  $RespostaProvaTableTable createAlias(String alias) {
    return $RespostaProvaTableTable(attachedDatabase, alias);
  }
}

abstract class _$RespostasDatabase extends GeneratedDatabase {
  _$RespostasDatabase(QueryExecutor e) : super(e);
  _$RespostasDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $RespostaProvaTableTable respostaProvaTable =
      $RespostaProvaTableTable(this);
  late final RespostaProvaDao respostaProvaDao =
      RespostaProvaDao(this as RespostasDatabase);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [respostaProvaTable];
}
