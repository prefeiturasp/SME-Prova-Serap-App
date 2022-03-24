import 'package:appserap/dtos/versao_atualizacao.respose.dto.dart';
import 'package:chopper/chopper.dart';

part 'versao.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/versoes")
abstract class VersaoService extends ChopperService {
  static VersaoService create([ChopperClient? client]) => _$VersaoService(client);

  @Get()
  Future<Response<String>> getVersao();

  @Get(path: '/front')
  Future<Response<String>> getVersaoFront();

  @Get(path: '/atualizacao')
  Future<Response<VersaoAtualizacaoResponseDTO>> getAtualizacao();
}
