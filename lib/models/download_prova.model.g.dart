// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_prova.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadProva _$DownloadProvaFromJson(Map<String, dynamic> json) =>
    DownloadProva(
      id: json['id'] as int,
      tipo: $enumDecode(_$EnumDownloadTipoEnumMap, json['tipo']),
      downloadStatus: $enumDecodeNullable(
              _$EnumDownloadStatusEnumMap, json['downloadStatus']) ??
          EnumDownloadStatus.NAO_INICIADO,
      dataHoraInicio: DateTime.parse(json['dataHoraInicio'] as String),
    );

Map<String, dynamic> _$DownloadProvaToJson(DownloadProva instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': _$EnumDownloadTipoEnumMap[instance.tipo]!,
      'downloadStatus': _$EnumDownloadStatusEnumMap[instance.downloadStatus]!,
      'dataHoraInicio': instance.dataHoraInicio.toIso8601String(),
    };

const _$EnumDownloadTipoEnumMap = {
  EnumDownloadTipo.QUESTAO: 'QUESTAO',
  EnumDownloadTipo.ARQUIVO: 'ARQUIVO',
  EnumDownloadTipo.ALTERNATIVA: 'ALTERNATIVA',
  EnumDownloadTipo.CONTEXTO_PROVA: 'CONTEXTO_PROVA',
  EnumDownloadTipo.VIDEO: 'VIDEO',
  EnumDownloadTipo.AUDIO: 'AUDIO',
};

const _$EnumDownloadStatusEnumMap = {
  EnumDownloadStatus.NAO_INICIADO: 0,
  EnumDownloadStatus.BAIXANDO: 1,
  EnumDownloadStatus.PAUSADO: 2,
  EnumDownloadStatus.CONCLUIDO: 3,
  EnumDownloadStatus.ERRO: 4,
  EnumDownloadStatus.ATUALIZAR: 5,
};
