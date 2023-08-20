import 'dart:async';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'contexto_prova.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/contextos-provas")
abstract class ContextoProvaService extends ChopperService {

  @factoryMethod
  static ContextoProvaService create(ChopperClient client) => _$ContextoProvaService(client);

  @Get(path: '/{id}')
  Future<Response<ContextoProvaResponseDTO>> getContextoProva({
    @Path() required int id,
  });

  @Get(path: '/provas/{idProva}')
  Future<Response<List<ContextoProvaResponseDTO>>> getContextosPorProva({
    @Path() required int idProva,
  });
}
