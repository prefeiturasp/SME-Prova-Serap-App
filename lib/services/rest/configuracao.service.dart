import 'dart:async';
import 'package:appserap/dtos/data_hora_servidor.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'configuracao.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/configuracoes")
abstract class ConfiguracaoService extends ChopperService {
  static ConfiguracaoService create([ChopperClient? client]) => _$ConfiguracaoService(client);

  @Get(path: 'datahora')
  Future<Response<DataHoraServidorDTO>> getDataHoraServidor();
}
