import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/prova_status.enum.dart';

part 'prova.response.dto.g.dart';

@JsonSerializable()
class ProvaResponseDTO {
  final int id;
  final String descricao;

  final int itensQuantidade;

  final DateTime dataInicio;
  final DateTime dataFim;

  final String? senha;

  final EnumProvaStatus status;

  final int tempoExecucao;
  final int tempoExtra;
  final int tempoAlerta;

  final DateTime? dataInicioProvaAluno;
  final DateTime? dataFimProvaAluno;

  final ModalidadeEnum modalidade;

  final int quantidadeRespostaSincronizacao;
  final DateTime ultimaAlteracao;

  final String caderno;

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
    required this.caderno,
  });

  bool isFinalizada() {
    return status == EnumProvaStatus.FINALIZADA || status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE;
  }

  static const fromJson = _$ProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaResponseDTOToJson(this);

  Prova toProvaModel() {
    return Prova(
      id: id,
      descricao: descricao,
      itensQuantidade: itensQuantidade,
      dataInicio: dataInicio,
      tempoExecucao: tempoExecucao,
      tempoExtra: tempoExtra,
      tempoAlerta: tempoAlerta,
      quantidadeRespostaSincronizacao: quantidadeRespostaSincronizacao,
      ultimaAlteracao: ultimaAlteracao,
      status: status,
      dataInicioProvaAluno: dataInicioProvaAluno,
      dataFimProvaAluno: dataFimProvaAluno,
      senha: senha,
      dataFim: dataFim,
      caderno: caderno,
    );
  }

  @override
  String toString() {
    return 'ProvaResponseDTO(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, status: $status, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, caderno: $caderno)';
  }
}
