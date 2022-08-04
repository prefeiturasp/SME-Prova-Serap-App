import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_caderno.model.g.dart';

@JsonSerializable()
class ProvaCaderno implements Insertable<ProvaCaderno> {
  int provaId;
  String caderno;
  int questaoLegadId;
  int ordem;

  ProvaCaderno({
    required this.provaId,
    required this.caderno,
    required this.ordem,
    required this.questaoLegadId,
  });

  factory ProvaCaderno.fromJson(Map<String, dynamic> json) => _$ProvaCadernoFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaCadernoToJson(this);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ProvaCadernoTableCompanion(
      provaId: Value(provaId),
      caderno: Value(caderno),
      ordem: Value(ordem),
      questaoLegadId: Value(questaoLegadId),
    ).toColumns(nullToAbsent);
  }
}
