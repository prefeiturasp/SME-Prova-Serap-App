import 'dart:async';
import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'orientacao_inicial.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/configuracoes/")
abstract class OrientacaoInicialService extends ChopperService {
  static OrientacaoInicialService create([ChopperClient? client]) => _$OrientacaoInicialService(client);

  @Get(path: 'telas-boas-vindas')
  Future<Response<List<OrientacaoInicialResponseDTO>>> getOrientacoesIniciais();

}