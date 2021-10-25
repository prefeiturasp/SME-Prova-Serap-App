import 'dart:async';
import 'package:chopper/chopper.dart';

part 'usuario.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/usuarios")
abstract class UsuarioService extends ChopperService {
  static UsuarioService create([ChopperClient? client]) => _$UsuarioService(client);

  @Post(path: '/preferencias')
  Future<Response<bool>> atualizarPreferencias({
    @Field() required int tamanhoFonte,
    @Field() required int familiaFonte,
  });
}
