import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arquivo.model.g.dart';

@JsonSerializable()
class Arquivo implements Insertable<Arquivo> {
  int id;
  int legadoId;

  String caminho;
  String base64;

  Arquivo({
    required this.id,
    required this.legadoId,
    required this.caminho,
    required this.base64,
  });

  factory Arquivo.fromJson(Map<String, dynamic> json) => _$ArquivoFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoToJson(this);

  @override
  String toString() => 'Arquivo(id: $id, caminho: $caminho, base64: $base64)';

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ArquivosDbCompanion(
      id: Value(id),
      legadoId: Value(legadoId),
      caminho: Value(caminho),
      base64: Value(base64),
    ).toColumns(nullToAbsent);
  }
}
