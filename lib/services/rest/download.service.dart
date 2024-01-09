import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'download.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/downloads")
abstract class DownloadService extends ChopperService {

  @factoryMethod
  static DownloadService create(ChopperClient client) => _$DownloadService(client);

  @Post()
  Future<Response<String>> informarDownloadConcluido({
    @Field() required int provaId,
    @Field() required int tipoDispositivo,
    @Field() required String dispositivoId,
    @Field() required String modeloDispositivo,
    @Field() required String versao,
    @Field() required String dataHora,
  });

  @Delete()
  Future<Response<void>> removerDownloads({
    @Header('chave-api') required String chaveAPI,
    @Body() required List<String> ids,
  });
}
