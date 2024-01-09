import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'alternativa.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/alternativas")
abstract class AlternativaService extends ChopperService {

  @factoryMethod
  static AlternativaService create(ChopperClient client) => _$AlternativaService(client);

  @Get(path: '{idAlternativa}')
  Future<Response<AlternativaResponseDTO>> getAlternativa({@Path() required int idAlternativa});
}
