import 'package:json_annotation/json_annotation.dart';

part 'error.response.dto.g.dart';

@JsonSerializable()
class ErrorResponseDTO {
  final List<String> mensagens;
  final bool existemErros;
  ErrorResponseDTO({
    required this.mensagens,
    required this.existemErros,
  });

  static const fromJson = _$ErrorResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ErrorResponseDTOToJson(this);

  @override
  String toString() => 'ErrorResponseDTO(mensagens: $mensagens, existemErros: $existemErros)';
}
