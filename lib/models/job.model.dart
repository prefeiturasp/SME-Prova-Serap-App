import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job.model.g.dart';

@JsonSerializable()
class Job implements Insertable<Job> {
  String id;
  String nome;
  EnumJobStatus? statusUltimaExecucao;
  DateTime? ultimaExecucao;
  int intervalo;

  Job({
    required this.id,
    required this.nome,
    this.statusUltimaExecucao,
    this.ultimaExecucao,
    required this.intervalo,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);

  @override
  String toString() {
    return 'Job - nome: $nome, statusUltimaExecucao: $statusUltimaExecucao, ultimaExecucao: $ultimaExecucao';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return JobsTableCompanion(
      id: Value(id),
      nome: Value(nome),
      statusUltimaExecucao: Value(statusUltimaExecucao),
      ultimaExecucao: Value(ultimaExecucao),
      intervalo: Value(intervalo),
    ).toColumns(nullToAbsent);
  }
}
