import 'package:appserap/dtos/prova_resumo_tai.response.dto.dart';
import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:chopper/chopper.dart';

part 'prova_tai.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/provas-tai")
abstract class ProvaTaiService extends ChopperService {
  static ProvaTaiService create([ChopperClient? client]) => _$ProvaTaiService(client);

  @Get(path: 'existe-conexao-R')
  Future<Response<bool>> existeConexaoR();

  @Post(path: '{provaId}/iniciar-prova')
  Future<Response<bool>> iniciarProva({
    @Path() required int provaId,
    @Field() required int status,
    @Field() required int tipoDispositivo,
    @Field() int? dataInicio,
    @Field() int? dataFim,
  });

  @Post(path: '{provaId}/finalizar-prova')
  Future<Response<bool>> finalizarProva({
    @Path() required int provaId,
    @Field() required int status,
    @Field() required int tipoDispositivo,
    @Field() int? dataInicio,
    @Field() int? dataFim,
  });

  @Post(path: '{provaId}/obter-questao')
  Future<Response<QuestaoCompletaResponseDTO>> obterQuestao({
    @Path() required int provaId,
  });

  @Post(path: '{provaId}/proximo')
  Future<Response<bool>> proximaQuestao({
    @Path() required int provaId,
    @Body() required QuestaoRespostaDTO resposta,
  });

  @Get(path: '{provaId}/resumo')
  Future<Response<List<ProvaResumoTaiResponseDto>>> obterResumo({
    @Path() required int provaId,
  });
}
