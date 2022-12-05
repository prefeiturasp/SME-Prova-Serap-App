import 'package:appserap/dtos/prova_resultado_resumo.response.dto.dart';
import 'package:appserap/dtos/questao_completa_resposta.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'prova_resultado.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/prova-resultados")
abstract class ProvaResultadoService extends ChopperService {
  static ProvaResultadoService create([ChopperClient? client]) => _$ProvaResultadoService(client);

  @Get(path: '{provaId}/resumo')
  Future<Response<ProvaResultadoResumoResponseDto>> getResumoPorProvaId({
    @Path() required int provaId,
  });

  @Get(path: '{provaId}/{questaoLegadoId}/questao-completa')
  Future<Response<QuestaoCompletaRespostaResponseDto>> getQuestaoCompleta({
    @Path() required int provaId,
    @Path() required int questaoLegadoId,
  });
}
