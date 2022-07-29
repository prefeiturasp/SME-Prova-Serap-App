// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versao_dispositivo.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersaoDispositivoDto _$VersaoDispositivoDtoFromJson(
        Map<String, dynamic> json) =>
    VersaoDispositivoDto(
      versaoCodigo: json['versaoCodigo'] as int,
      versaoDescricao: json['versaoDescricao'] as String,
      dispositivoImei: json['dispositivoImei'] as String,
      atualizadoEm: DateTime.parse(json['atualizadoEm'] as String),
    );

Map<String, dynamic> _$VersaoDispositivoDtoToJson(
        VersaoDispositivoDto instance) =>
    <String, dynamic>{
      'versaoCodigo': instance.versaoCodigo,
      'versaoDescricao': instance.versaoDescricao,
      'dispositivoImei': instance.dispositivoImei,
      'atualizadoEm': instance.atualizadoEm.toIso8601String(),
    };
