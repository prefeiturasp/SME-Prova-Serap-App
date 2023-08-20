import 'package:appserap/dtos/versao_atualizacao.respose.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'versao.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/versoes")
abstract class VersaoService extends ChopperService {

  @factoryMethod
  static VersaoService create(ChopperClient client) => _$VersaoService(client);

  @Get()
  Future<Response<String>> getVersao();

  @Get(path: '/front')
  Future<Response<String>> getVersaoFront();

  @Get(path: '/atualizacao')
  Future<Response<VersaoAtualizacaoResponseDTO>> getAtualizacao();

  @Post(path: '/dispositivo')
  Future<Response<bool>> informarVersao({
    @Header('chave-api') required String chaveAPI,
    @Field() required int versaoCodigo,
    @Field() required String versaoDescricao,
    @Field() String? dispositivoImei,
    @Field() required String atualizadoEm,
    @Field() String? dispositivoId,
  });
}
