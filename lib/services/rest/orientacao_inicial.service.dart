import 'dart:async';
import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'orientacao_inicial.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/configuracoes/")
abstract class OrientacaoInicialService extends ChopperService {

  @factoryMethod
  static OrientacaoInicialService create(ChopperClient client) => _$OrientacaoInicialService(client);

  @Get(path: 'telas-boas-vindas')
  Future<Response<List<OrientacaoInicialResponseDTO>>> getOrientacoesIniciais();

}