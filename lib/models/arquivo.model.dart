import 'package:json_annotation/json_annotation.dart';

part 'arquivo.model.g.dart';

@JsonSerializable()
class Arquivo {
  int id;
  String caminho;
  String base64;

  Arquivo({
    required this.id,
    required this.caminho,
    required this.base64,
  });

  factory Arquivo.fromJson(Map<String, dynamic> json) => _$ArquivoFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoToJson(this);

  @override
  String toString() => 'Arquivo(id: $id, caminho: $caminho, base64: $base64)';
}
