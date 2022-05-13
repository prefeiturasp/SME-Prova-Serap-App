import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'autenticacao_dados.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoDadosResponseDTO {
  String nome;
  String ano;
  String tipoTurno;
  double tamanhoFonte;
  FonteTipoEnum familiaFonte;
  ModalidadeEnum modalidade;
  int inicioTurno;
  int fimTurno;

  String dreAbreviacao;
  String escola;
  String turma;

  List<DeficienciaEnum> deficiencias;

  AutenticacaoDadosResponseDTO(
    this.nome,
    this.ano,
    this.tipoTurno,
    this.tamanhoFonte,
    this.familiaFonte,
    this.modalidade,
    this.inicioTurno,
    this.fimTurno,
    this.dreAbreviacao,
    this.escola,
    this.turma,
    this.deficiencias,
  );

  static const fromJson = _$AutenticacaoDadosResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDadosResponseDTOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutenticacaoDadosResponseDTO &&
        other.nome == nome &&
        other.ano == ano &&
        other.tipoTurno == tipoTurno;
  }

  @override
  int get hashCode => nome.hashCode ^ ano.hashCode ^ tipoTurno.hashCode;
}
