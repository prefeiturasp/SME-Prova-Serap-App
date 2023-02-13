// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResponseDTO _$ProvaResponseDTOFromJson(Map<String, dynamic> json) =>
    ProvaResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      itensQuantidade: json['itensQuantidade'] as int,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: DateTime.parse(json['dataFim'] as String),
      status: $enumDecode(_$EnumProvaStatusEnumMap, json['status']),
      senha: json['senha'] as String?,
      tempoExecucao: json['tempoExecucao'] as int,
      tempoExtra: json['tempoExtra'] as int,
      tempoAlerta: json['tempoAlerta'] as int,
      dataInicioProvaAluno: json['dataInicioProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataInicioProvaAluno'] as String),
      dataFimProvaAluno: json['dataFimProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataFimProvaAluno'] as String),
      modalidade: $enumDecode(_$ModalidadeEnumEnumMap, json['modalidade']),
      quantidadeRespostaSincronizacao:
          json['quantidadeRespostaSincronizacao'] as int,
      ultimaAlteracao: DateTime.parse(json['ultimaAlteracao'] as String),
      caderno: json['caderno'] as String,
      provaComProficiencia: json['provaComProficiencia'] as bool,
      apresentarResultados: json['apresentarResultados'] as bool,
      apresentarResultadosPorItem: json['apresentarResultadosPorItem'] as bool,
      formatoTai: json['formatoTai'] as bool,
      formatoTaiItem: json['formatoTaiItem'] as int?,
      formatoTaiAvancarSemResponder:
          json['formatoTaiAvancarSemResponder'] as bool,
      formatoTaiVoltarItemAnterior:
          json['formatoTaiVoltarItemAnterior'] as bool,
      exibirVideo: json['exibirVideo'] as bool,
      exibirAudio: json['exibirAudio'] as bool,
    );

Map<String, dynamic> _$ProvaResponseDTOToJson(ProvaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'itensQuantidade': instance.itensQuantidade,
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim.toIso8601String(),
      'senha': instance.senha,
      'status': _$EnumProvaStatusEnumMap[instance.status]!,
      'tempoExecucao': instance.tempoExecucao,
      'tempoExtra': instance.tempoExtra,
      'tempoAlerta': instance.tempoAlerta,
      'dataInicioProvaAluno': instance.dataInicioProvaAluno?.toIso8601String(),
      'dataFimProvaAluno': instance.dataFimProvaAluno?.toIso8601String(),
      'modalidade': _$ModalidadeEnumEnumMap[instance.modalidade]!,
      'quantidadeRespostaSincronizacao':
          instance.quantidadeRespostaSincronizacao,
      'ultimaAlteracao': instance.ultimaAlteracao.toIso8601String(),
      'caderno': instance.caderno,
      'provaComProficiencia': instance.provaComProficiencia,
      'apresentarResultados': instance.apresentarResultados,
      'apresentarResultadosPorItem': instance.apresentarResultadosPorItem,
      'formatoTai': instance.formatoTai,
      'formatoTaiItem': instance.formatoTaiItem,
      'formatoTaiAvancarSemResponder': instance.formatoTaiAvancarSemResponder,
      'formatoTaiVoltarItemAnterior': instance.formatoTaiVoltarItemAnterior,
      'exibirVideo': instance.exibirVideo,
      'exibirAudio': instance.exibirAudio,
    };

const _$EnumProvaStatusEnumMap = {
  EnumProvaStatus.NAO_INICIADA: 0,
  EnumProvaStatus.INICIADA: 1,
  EnumProvaStatus.FINALIZADA: 2,
  EnumProvaStatus.PENDENTE: 3,
  EnumProvaStatus.EM_REVISAO: 4,
  EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE: 5,
};

const _$ModalidadeEnumEnumMap = {
  ModalidadeEnum.NAO_CADASTRADO: 0,
  ModalidadeEnum.EI: 1,
  ModalidadeEnum.EJA: 3,
  ModalidadeEnum.CIEJA: 4,
  ModalidadeEnum.FUNDAMENTAL: 5,
  ModalidadeEnum.MEDIO: 6,
  ModalidadeEnum.CMCT: 7,
  ModalidadeEnum.MOVA: 8,
  ModalidadeEnum.ETEC: 9,
};
