import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/questao.model.dart';

part 'prova.model.g.dart';

@JsonSerializable()
class Prova {
  int id;
  String descricao;
  int itensQuantidade;
  DateTime dataInicio;
  DateTime? dataFim;

  List<Questao> questoes;

  EnumDownloadStatus status;
  double progressoDownload;

  Prova({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    this.dataFim,
    required this.questoes,
    this.status = EnumDownloadStatus.NAO_INICIADO,
    this.progressoDownload = 0,
  });

  factory Prova.fromJson(Map<String, dynamic> json) => _$ProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaToJson(this);

  @override
  String toString() {
    return 'Prova(id: $id, status: $status, progressoDownload: $progressoDownload, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, questoes: $questoes)';
  }
}
