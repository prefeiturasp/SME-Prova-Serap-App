import 'dart:async';
import 'package:appserap/dtos/data_hora_servidor.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'configuracao.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/configuracoes")
abstract class ConfiguracaoService extends ChopperService {

  @factoryMethod
  static ConfiguracaoService create(ChopperClient client) => _$ConfiguracaoService(client);

  @Get(path: 'datahora')
  Future<Response<DataHoraServidorDTO>> getDataHoraServidor();
}
