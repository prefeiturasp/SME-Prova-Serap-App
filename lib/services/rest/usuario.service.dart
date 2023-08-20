import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'usuario.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/usuarios")
abstract class UsuarioService extends ChopperService {

  @factoryMethod
  static UsuarioService create(ChopperClient client) => _$UsuarioService(client);

  @Post(path: '/preferencias')
  Future<Response<bool>> atualizarPreferencias({
    @Field() required int tamanhoFonte,
    @Field() required int familiaFonte,
  });
}
