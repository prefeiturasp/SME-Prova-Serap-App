import 'package:appserap/dtos/questao_resposta.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'questao_resposta.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/questoes")
abstract class QuestaoRespostaService extends ChopperService {
  static QuestaoRespostaService create([ChopperClient? client]) => _$QuestaoRespostaService(client);

  @Get(path: '{questaoId}/respostas')
  Future<Response<QuestaoRespostaResponseDTO>> getRespostaPorQuestaoId({@Path() required int questaoId});

  @Post(path: '/respostas')
  Future<Response<bool>> postResposta({
    @Field() required int questaoId,
    @Field() int? alternativaId,
    @Field() String? resposta,
    @Field() required int dataHoraRespostaTicks,
    @Field() int? tempoRespostaAluno,
  });
}
