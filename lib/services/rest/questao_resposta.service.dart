import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:chopper/chopper.dart';

part 'questao_resposta.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/questoes/respostas")
abstract class QuestaoRespostaService extends ChopperService {
  static QuestaoRespostaService create([ChopperClient? client]) => _$QuestaoRespostaService(client);

  @Post()
  Future<Response<QuestaoRespostaDTO>> enviar({
    @Field() required int questaoId,
    @Field() int? alternativaId,
    @Field() String? resposta,
    @Field() required int dataHoraRespostaTicks,
  });
}
