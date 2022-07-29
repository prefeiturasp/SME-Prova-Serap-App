import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contexto_prova.model.g.dart';

@JsonSerializable()
class ContextoProva {
  int? id;
  int? provaId;
  String? imagem;
  String? imagemBase64;
  PosicionamentoImagemEnum? posicionamento;
  int? ordem;
  String? titulo;
  String? texto;

  ContextoProva({
    this.id,
    this.provaId,
    this.imagem,
    this.imagemBase64,
    this.posicionamento,
    this.ordem,
    this.titulo,
    this.texto,
  });

  factory ContextoProva.fromJson(Map<String, dynamic> json) =>
      _$ContextoProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ContextoProvaToJson(this);

  @override
  String toString() {
    return 'ContextoProva(id: $id, provaId: $provaId, imagem: $imagem, posicionamento: $posicionamento, ordem: $ordem, titulo: $titulo, texto: $texto)';
  }
}
