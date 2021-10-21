import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'alternativa.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/alternativas")
abstract class AlternativaService extends ChopperService {
  static AlternativaService create([ChopperClient? client]) => _$AlternativaService(client);

  @Get(path: '{idAlternativa}')
  Future<Response<AlternativaResponseDTO>> getAlternativa({@Path() required int idAlternativa});
}
