import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/questao.model.dart';

part 'prova.model.g.dart';

@JsonSerializable()
class Prova {
  int id;
  String descricao;
  int itensQuantidade;
  DateTime dataInicio;
  DateTime? dataFim;

  int tempoExecucao;
  int tempoExtra;
  int? tempoAlerta;

  DateTime? dataInicioProvaAluno;
  DateTime? dataFimProvaAluno;

  List<Questao> questoes;

  EnumDownloadStatus downloadStatus;
  double downloadProgresso;

  EnumProvaStatus status;

  String? senha;

  Prova({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    this.dataFim,
    required this.tempoExecucao,
    required this.tempoExtra,
    required this.tempoAlerta,
    required this.questoes,
    this.downloadStatus = EnumDownloadStatus.NAO_INICIADO,
    this.downloadProgresso = 0,
    this.status = EnumProvaStatus.NAO_INICIADA,
    this.senha,
    this.dataInicioProvaAluno,
    this.dataFimProvaAluno,
  });

  factory Prova.fromJson(Map<String, dynamic> json) => _$ProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaToJson(this);

  static Prova? carregaProvaCache(int idProva) {
    var _pref = GetIt.I.get<SharedPreferences>();

    String? provaJson = _pref.getString('prova_$idProva');

    if (provaJson != null) {
      return Prova.fromJson(jsonDecode(provaJson));
    }
  }

  static salvaProvaCache(Prova prova) async {
    SharedPreferences prefs = GetIt.I.get();
    await prefs.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }

  @override
  String toString() {
    return 'Prova(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, questoes: $questoes, downloadStatus: $downloadStatus, downloadProgresso: $downloadProgresso, status: $status)';
  }
}
