import 'package:appserap/enums/modalidade.enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/prova_status.enum.dart';

part 'prova.response.dto.g.dart';

@JsonSerializable()
class ProvaResponseDTO {
  int id;
  String descricao;

  int itensQuantidade;

  DateTime dataInicio;
  DateTime dataFim;

  String? senha;

  EnumProvaStatus status;

  int tempoExecucao;
  int tempoExtra;
  int tempoAlerta;

  DateTime? dataInicioProvaAluno;
  DateTime? dataFimProvaAluno;

  ModalidadeEnum modalidade;

  int quantidadeRespostaSincronizacao;
  DateTime ultimaAlteracao;

  ProvaResponseDTO({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    this.senha,
    required this.tempoExecucao,
    required this.tempoExtra,
    required this.tempoAlerta,
    required this.dataInicioProvaAluno,
    this.dataFimProvaAluno,
    required this.modalidade,
    required this.quantidadeRespostaSincronizacao,
    required this.ultimaAlteracao,
  });

  bool isFinalizada() {
    return status == EnumProvaStatus.FINALIZADA || status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE;
  }

  static const fromJson = _$ProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaResponseDTOToJson(this);

  @override
  String toString() {
    return 'ProvaResponseDTO(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, status: $status, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno)';
  }
}
