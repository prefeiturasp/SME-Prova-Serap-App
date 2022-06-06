import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_aluno.model.g.dart';

@JsonSerializable()
class ProvaAluno implements Insertable<ProvaAluno> {
  String codigoEOL;
  int provaId;

  ProvaAluno({
    required this.codigoEOL,
    required this.provaId,
  });

  factory ProvaAluno.fromJson(Map<String, dynamic> json) => _$ProvaAlunoFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaAlunoToJson(this);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ProvaAlunoTableCompanion(
      codigoEOL: Value(codigoEOL),
      provaId: Value(provaId),
    ).toColumns(nullToAbsent);
  }
}
