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

  final bool provaComProficiencia;
  final bool apresentarResultados;
  final bool apresentarResultadosPorItem;

  final bool formatoTai;
  final int? formatoTaiItem;
  final bool formatoTaiAvancarSemResponder;
  final bool formatoTaiVoltarItemAnterior;

  final bool exibirVideo;
  final bool exibirAudio;

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
    required this.provaComProficiencia,
    required this.apresentarResultados,
    required this.apresentarResultadosPorItem,
    required this.formatoTai,
    required this.formatoTaiItem,
    required this.formatoTaiAvancarSemResponder,
    required this.formatoTaiVoltarItemAnterior,
    required this.exibirVideo,
    required this.exibirAudio,
  });

  bool isFinalizada() {
    return status == EnumProvaStatus.FINALIZADA ||
        status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_JOB ||
        status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_TEMPO ||
        status == EnumProvaStatus.FINALIZADA_OFFLINE;
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
      provaComProficiencia: provaComProficiencia,
      apresentarResultados: apresentarResultados,
      apresentarResultadosPorItem: apresentarResultadosPorItem,
      formatoTai: formatoTai,
      formatoTaiItem: formatoTaiItem,
      formatoTaiAvancarSemResponder: formatoTaiAvancarSemResponder,
      formatoTaiVoltarItemAnterior: formatoTaiVoltarItemAnterior,
      exibirVideo: exibirVideo,
      exibirAudio: exibirAudio,
    );
  }

  @override
  String toString() {
    return 'ProvaResponseDTO(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, status: $status, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, caderno: $caderno)';
  }
}
