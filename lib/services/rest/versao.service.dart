import 'package:chopper/chopper.dart';

part 'versao.service.chopper.dart';

@ChopperApi(baseUrl: "/versoes")
abstract class VersaoService extends ChopperService {
  static VersaoService create([ChopperClient? client]) => _$VersaoService(client);

  @Get()
  Future<Response<String>> getVersao();

  @Get(path: '/front')
  Future<Response<String>> getVersaoFront();
}
