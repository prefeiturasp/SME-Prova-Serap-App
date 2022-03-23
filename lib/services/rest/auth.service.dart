import 'dart:async';
import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/dtos/autenticacao_dados.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'auth.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/autenticacao")
abstract class AutenticacaoService extends ChopperService {
  static AutenticacaoService create([ChopperClient? client]) => _$AutenticacaoService(client);

  @Post()
  Future<Response<AutenticacaoResponseDTO>> login({
    @Field() required String login,
    @Field() required String senha,
  });

  @Post(path: 'revalidar')
  Future<Response<AutenticacaoResponseDTO>> revalidar({
    @Field() required String token,
  });

  @Get(path: 'meus-dados')
  Future<Response<AutenticacaoDadosResponseDTO>> meusDados();
}
