import 'package:json_annotation/json_annotation.dart';

part 'download.response.dto.g.dart';

@JsonSerializable()
class DownloadResponseDTO {
  int id;

  DownloadResponseDTO(
    this.id,
  );

  static const fromJson = _$DownloadResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$DownloadResponseDTOToJson(this);

  @override
  String toString() => 'DownloadResponseDTO(id: $id)';
}
