import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'prova.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/provas")
abstract class ProvaService extends ChopperService {
  static ProvaService create([ChopperClient? client]) => _$ProvaService(client);

  @Get()
  Future<Response<List<ProvaResponseDTO>>> getProvas();

  @Get(path: '{idProva}/detalhes-resumido')
  Future<Response<ProvaDetalhesResponseDTO>> getResumoProva({
    @Path() required int idProva,
  });

  @Get(path: '{idProva}/status-aluno')
  Future<Response<int>> getStatusProva({
    @Path() required int idProva,
  });

  @Post(path: '{idProva}/status-aluno')
  Future<Response<bool>> setStatusProva({
    @Path() required int idProva,
    @Field() required int status,
  });
}
