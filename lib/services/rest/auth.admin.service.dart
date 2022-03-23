import 'dart:async';
import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'auth.admin.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/admin/autenticacao")
abstract class AutenticacaoAdminService extends ChopperService {
  static AutenticacaoAdminService create([ChopperClient? client]) => _$AutenticacaoAdminService(client);

  @Post(path: 'validar')
  Future<Response<AutenticacaoResponseDTO>> loginByCodigoAutenticacao({
    @Field() required String codigo,
  });

  @Post(path: 'revalidar')
  Future<Response<AutenticacaoResponseDTO>> revalidar({
    @Field() required String token,
  });
}
