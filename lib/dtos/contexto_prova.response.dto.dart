import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contexto_prova.response.dto.g.dart';

@JsonSerializable()
class ContextoProvaResponseDTO {
  int id;
  int provaId;
  String imagem;
  PosicionamentoImagemEnum posicionamento;
  int ordem;
  String titulo;
  String texto;

  ContextoProvaResponseDTO({
    required this.id,
    required this.provaId,
    required this.imagem,
    required this.posicionamento,
    required this.ordem,
    required this.titulo,
    required this.texto,
  });

  static const fromJson = _$ContextoProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ContextoProvaResponseDTOToJson(this);

  @override
  String toString() {
    return 'ContextoProva(id: $id, provaId: $provaId, imagem: $imagem, posicionamento: $posicionamento, ordem: $ordem, titulo: $titulo, texto: $texto)';
  }
}
