// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_hora_servidor.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataHoraServidorDTO _$DataHoraServidorDTOFromJson(Map<String, dynamic> json) =>
    DataHoraServidorDTO(
      DateTime.parse(json['dataHora'] as String),
      json['tolerancia'] as int,
    );

Map<String, dynamic> _$DataHoraServidorDTOToJson(
        DataHoraServidorDTO instance) =>
    <String, dynamic>{
      'dataHora': instance.dataHora.toIso8601String(),
      'tolerancia': instance.tolerancia,
    };
