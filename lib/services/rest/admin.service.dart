import 'dart:async';
import 'package:appserap/dtos/admin_questao_detalhes.response.dto.dart';
import 'package:appserap/dtos/listagem_prova.admin.response.dto.dart';
import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/dtos/admin_prova_caderno.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'admin.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/admin")
abstract class AdminService extends ChopperService {
  static AdminService create([ChopperClient? client]) => _$AdminService(client);

  @Get(path: "provas")
  Future<Response<ListagemAdminProvaResponseDTO>> getProvas({
    @Query() int? quantidadeRegistros,
    @Query() int? numeroPagina,
    @Query() int? provaLegadoId,
    @Query() int? modalidade,
    @Query() String? descricao,
    @Query() String? ano,
  });

  @Get(path: "provas/{idProva}/cadernos")
  Future<Response<AdminProvaCadernoResponseDTO>> getCadernos({@Path() required int idProva});

  @Get(path: "provas/{idProva}/resumos")
  Future<Response<List<AdminProvaResumoResponseDTO>>> getResumo({@Path() required int idProva});

  @Get(path: "provas/{idProva}/cadernos/{caderno}/resumos")
  Future<Response<List<AdminProvaResumoResponseDTO>>> getResumoByCaderno({
    @Path() required int idProva,
    @Path() required String caderno,
  });

  @Get(path: "provas/{idProva}/questoes/{idQuestao}/detalhes")
  Future<Response<AdminQuestaoDetalhesResponseDTO>> getDetalhes({
    @Path() required int idProva,
    @Path() required int idQuestao,
  });
}
