// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminProvaResponseDTO _$AdminProvaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AdminProvaResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      dataInicioDownload: json['dataInicioDownload'] == null
          ? null
          : DateTime.parse(json['dataInicioDownload'] as String),
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: json['dataFim'] == null
          ? null
          : DateTime.parse(json['dataFim'] as String),
      tempoExecucao: json['tempoExecucao'] as int,
      totalItens: json['totalItens'] as int,
      totalCadernos: json['totalCadernos'] as int,
      senha: json['senha'] as String?,
      possuiBIB: json['possuiBIB'] as bool,
      possuiContexto: json['possuiContexto'] as bool,
    );

Map<String, dynamic> _$AdminProvaResponseDTOToJson(
        AdminProvaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'dataInicioDownload': instance.dataInicioDownload?.toIso8601String(),
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim?.toIso8601String(),
      'tempoExecucao': instance.tempoExecucao,
      'totalItens': instance.totalItens,
      'possuiBIB': instance.possuiBIB,
      'totalCadernos': instance.totalCadernos,
      'senha': instance.senha,
      'possuiContexto': instance.possuiContexto,
    };
