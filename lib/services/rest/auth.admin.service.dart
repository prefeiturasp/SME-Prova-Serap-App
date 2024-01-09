import 'dart:async';
import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'auth.admin.service.chopper.dart';

@injectable
@ChopperApi(baseUrl: "/v1/admin/autenticacao")
abstract class AutenticacaoAdminService extends ChopperService {

  @factoryMethod
  static AutenticacaoAdminService create(ChopperClient client) => _$AutenticacaoAdminService(client);

  @Post(path: 'validar')
  Future<Response<AutenticacaoResponseDTO>> loginByCodigoAutenticacao({
    @Field() required String codigo,
  });

  @Post(path: 'revalidar')
  Future<Response<AutenticacaoResponseDTO>> revalidar({
    @Field() required String token,
  });
}
