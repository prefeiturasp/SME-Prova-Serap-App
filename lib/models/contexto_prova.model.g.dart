// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contexto_prova.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextoProva _$ContextoProvaFromJson(Map<String, dynamic> json) =>
    ContextoProva(
      id: json['id'] as int,
      provaId: json['provaId'] as int,
      imagem: json['imagem'] as String,
      imagemBase64: json['imagemBase64'] as String,
      posicionamento: $enumDecode(
          _$PosicionamentoImagemEnumEnumMap, json['posicionamento']),
      ordem: json['ordem'] as int,
      titulo: json['titulo'] as String,
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$ContextoProvaToJson(ContextoProva instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provaId': instance.provaId,
      'imagem': instance.imagem,
      'imagemBase64': instance.imagemBase64,
      'posicionamento':
          _$PosicionamentoImagemEnumEnumMap[instance.posicionamento]!,
      'ordem': instance.ordem,
      'titulo': instance.titulo,
      'texto': instance.texto,
    };

const _$PosicionamentoImagemEnumEnumMap = {
  PosicionamentoImagemEnum.NAO_CADASTRADO: 0,
  PosicionamentoImagemEnum.DIREITA: 1,
  PosicionamentoImagemEnum.CENTRO: 2,
  PosicionamentoImagemEnum.ESQUERDA: 3,
};
