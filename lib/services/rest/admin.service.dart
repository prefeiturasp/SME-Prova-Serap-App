import 'dart:async';
import 'package:appserap/dtos/listagem_prova.admin.response.dto.dart';
import 'package:appserap/dtos/prova_caderno.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'admin.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/admin")
abstract class AdminService extends ChopperService {
  static AdminService create([ChopperClient? client]) => _$AdminService(client);

  @Get(path: "provas")
  Future<Response<ListagemProvaAdminResponseDTO>> getProvas();
}
