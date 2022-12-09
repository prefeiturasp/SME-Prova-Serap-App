import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'prova_tai.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/provas-tai")
abstract class ProvaTaiService extends ChopperService {
  static ProvaTaiService create([ChopperClient? client]) => _$ProvaTaiService(client);

  @Post(path: '{provaId}/iniciar-prova')
  Future<Response<bool>> iniciarProva({
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
}
