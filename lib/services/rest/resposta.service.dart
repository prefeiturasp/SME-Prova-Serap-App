import 'package:appserap/dtos/prova_resposta.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'resposta.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/questoes/respostas")
abstract class RespostaService extends ChopperService {
  static RespostaService create([ChopperClient? client]) => _$RespostaService(client);

  @Post()
  Future<Response<ProvaRespostaDTO>> login({
    @Field() required int questaoId,
    @Field() int? alternativaId,
    @Field() String? resposta,
    @Field() required bool sincronizado,
    @Field() required int dataHoraRespostaTicks,
  });
}
