import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contexto_prova.model.g.dart';

@JsonSerializable()
class ContextoProva implements Insertable<ContextoProva> {
  int id;
  int provaId;
  String imagem;
  String imagemBase64;
  PosicionamentoImagemEnum posicionamento;
  int ordem;
  String titulo;
  String texto;

  ContextoProva({
    required this.id,
    required this.provaId,
    required this.imagem,
    required this.imagemBase64,
    required this.posicionamento,
    required this.ordem,
    required this.titulo,
    required this.texto,
  });

  factory ContextoProva.fromJson(Map<String, dynamic> json) => _$ContextoProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ContextoProvaToJson(this);

  @override
  String toString() {
    return 'ContextoProva(id: $id, provaId: $provaId, imagem: $imagem, posicionamento: $posicionamento, ordem: $ordem, titulo: $titulo, texto: $texto)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ContextosProvaDbCompanion(
      id: Value(id),
      provaId: Value(provaId),
      imagem: Value(imagem),
      imagemBase64: Value(imagemBase64),
      posicionamento: Value(posicionamento),
      ordem: Value(ordem),
      titulo: Value(titulo),
      texto: Value(texto),
    ).toColumns(nullToAbsent);
  }
}
