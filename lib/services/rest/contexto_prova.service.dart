import 'dart:async';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'contexto_prova.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/contextos-provas")
abstract class ContextoProvaService extends ChopperService {
  static ContextoProvaService create([ChopperClient? client]) => _$ContextoProvaService(client);

  @Get(path: '/{id}')
  Future<Response<ContextoProvaResponseDTO>> getContextoProva({
    @Path() required int id,
  });

  @Get(path: '/provas/{id}')
  Future<Response<List<ContextoProvaResponseDTO>>> getContextosPorProva({
    @Path() required int idProva,
  });
}
