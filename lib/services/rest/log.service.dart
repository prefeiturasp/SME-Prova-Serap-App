import 'package:chopper/chopper.dart';

part 'log.service.chopper.dart';

@ChopperApi(baseUrl: "/v1")
abstract class LogService extends ChopperService {
  static LogService create([ChopperClient? client]) => _$LogService(client);

  @Post(path: '/imagemLog')
  Future<Response<bool>> logarNecessidadeDeUsoDaUrl({
    @Header('chave-api') required String chaveAPI,
    @Field() required String prova,
    @Field() required String aluno,
    @Field() required String escola,
    @Field() required String html,
  });
}
