import 'dart:async';
import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'usuario.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/usuarios")
abstract class UsuarioService extends ChopperService {
  static UsuarioService create([ChopperClient? client]) => _$UsuarioService(client);

  @Post(path: '/preferencias')
  Future<Response<AutenticacaoResponseDTO>> atualizarPreferencias({
    @Field() required double tamanhoFonte,
    @Field() required int familiaFonte,
  });

}
