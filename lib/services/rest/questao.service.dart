import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'questao.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/questoes")
abstract class QuestaoService extends ChopperService {
  static QuestaoService create([ChopperClient? client]) => _$QuestaoService(client);

  @Get(path: '{idQuestao}')
  Future<Response<QuestaoResponseDTO>> getQuestao({
    @Path() required int idQuestao,
  });

  @Get(path: 'completas')
  Future<Response<List<QuestaoCompletaResponseDTO>>> getQuestaoCompleta({
    @Query() required List<int> ids,
  });
}
