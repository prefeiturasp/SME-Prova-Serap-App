import 'package:json_annotation/json_annotation.dart';

part 'versao_atualizacao.respose.dto.g.dart';

@JsonSerializable()
class VersaoAtualizacaoResponseDTO {
  int? versionCode;
  String? versionName;
  String? contentText;
  int? minSupport;
  String? url;

  VersaoAtualizacaoResponseDTO({
    this.versionCode,
    this.versionName,
    this.contentText,
    this.minSupport,
    this.url,
  });

  static const fromJson = _$VersaoAtualizacaoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$VersaoAtualizacaoResponseDTOToJson(this);
}
