import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'arquivo.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/arquivos")
abstract class ArquivoService extends ChopperService {

  @factoryMethod
  static ArquivoService create(ChopperClient client) => _$ArquivoService(client);

  @Get(path: '{idArquivo}/legado')
  Future<Response<ArquivoResponseDTO>> getArquivo({@Path() required int idArquivo});

  @Get(path: 'audio/{idArquivo}')
  Future<Response<ArquivoResponseDTO>> getAudio({@Path() required int idArquivo});

  @Get(path: 'video/{idArquivo}')
  Future<Response<ArquivoVideoResponseDTO>> getVideo({@Path() required int idArquivo});
}
