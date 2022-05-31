// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_prova.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadProva _$DownloadProvaFromJson(Map<String, dynamic> json) =>
    DownloadProva(
      id: json['id'] as int,
      tipo: _$enumDecode(_$EnumDownloadTipoEnumMap, json['tipo']),
      downloadStatus: _$enumDecodeNullable(
              _$EnumDownloadStatusEnumMap, json['downloadStatus']) ??
          EnumDownloadStatus.NAO_INICIADO,
      dataHoraInicio: DateTime.parse(json['dataHoraInicio'] as String),
    );

Map<String, dynamic> _$DownloadProvaToJson(DownloadProva instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': _$EnumDownloadTipoEnumMap[instance.tipo],
      'downloadStatus': _$EnumDownloadStatusEnumMap[instance.downloadStatus],
      'dataHoraInicio': instance.dataHoraInicio.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$EnumDownloadTipoEnumMap = {
  EnumDownloadTipo.QUESTAO: 'QUESTAO',
  EnumDownloadTipo.ARQUIVO: 'ARQUIVO',
  EnumDownloadTipo.ALTERNATIVA: 'ALTERNATIVA',
  EnumDownloadTipo.CONTEXTO_PROVA: 'CONTEXTO_PROVA',
  EnumDownloadTipo.VIDEO: 'VIDEO',
  EnumDownloadTipo.AUDIO: 'AUDIO',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$EnumDownloadStatusEnumMap = {
  EnumDownloadStatus.NAO_INICIADO: 0,
  EnumDownloadStatus.BAIXANDO: 1,
  EnumDownloadStatus.PAUSADO: 2,
  EnumDownloadStatus.CONCLUIDO: 3,
  EnumDownloadStatus.ERRO: 4,
};
