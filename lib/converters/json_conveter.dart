import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/dtos/admin_questao_detalhes.response.dto.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/autenticacao.dto.dart';
import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/dtos/autenticacao_dados.response.dto.dart';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/dtos/listagem_prova.admin.response.dto.dart';
import 'package:appserap/dtos/preferencias_usuario.response.dto.dart';
import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:appserap/dtos/admin_prova.response.dto.dart';
import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/dtos/prova_anterior.response.dto.dart';
import 'package:appserap/dtos/admin_prova_caderno.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno_questao.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:appserap/dtos/questao_detalhes_legado.response.dto.dart';
import 'package:appserap/dtos/questao_resposta.response.dto.dart';
import 'package:appserap/dtos/versao_atualizacao.respose.dto.dart';
import 'package:chopper/chopper.dart' hide Post;
import 'package:logging/logging.dart';

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final log = Logger('JsonSerializableConverter');
  final Map<String, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  T? _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T.toString()];
    log.finest("jsonFactory: $jsonFactory");

    if (jsonFactory == null) {
      log.warning("jsonFactory is null");
      return null;
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(List values) {
    return values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();
  }

  dynamic _decode<T>(entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity as List);
    }

    if (entity is Map) {
      return _decodeMap<T>(entity as Map<String, dynamic>);
    }
    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    final jsonRes = super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }
}

final jsonConverter = JsonSerializableConverter({
  "AutenticacaoDTO": AutenticacaoDTO.fromJson,
  "AutenticacaoDadosResponseDTO": AutenticacaoDadosResponseDTO.fromJson,
  "AutenticacaoResponseDTO": AutenticacaoResponseDTO.fromJson,
  "ProvaDetalhesResponseDTO": ProvaDetalhesResponseDTO.fromJson,
  "QuestaoResponseDTO": QuestaoResponseDTO.fromJson,
  "ArquivoResponseDTO": ArquivoResponseDTO.fromJson,
  "AlternativaResponseDTO": AlternativaResponseDTO.fromJson,
  "ProvaResponseDTO": ProvaResponseDTO.fromJson,
  "QuestaoRespostaResponseDTO": QuestaoRespostaResponseDTO.fromJson,
  "PreferenciasUsuarioResponseDTO": PreferenciasUsuarioResponseDTO.fromJson,
  "OrientacaoInicialResponseDTO": OrientacaoInicialResponseDTO.fromJson,
  "ContextoProvaResponseDTO": ContextoProvaResponseDTO.fromJson,
  "ProvaAnteriorResponseDTO": ProvaAnteriorResponseDTO.fromJson,
  "ArquivoVideoResponseDTO": ArquivoVideoResponseDTO.fromJson,
  "ListagemAdminProvaResponseDTO": ListagemAdminProvaResponseDTO.fromJson,
  "AdminProvaResponseDTO": AdminProvaResponseDTO.fromJson,
  "AdminProvaCadernoResponseDTO": AdminProvaCadernoResponseDTO.fromJson,
  "AdminProvaResumoResponseDTO": AdminProvaResumoResponseDTO.fromJson,
  "AdminQuestaoDetalhesResponseDTO": AdminQuestaoDetalhesResponseDTO.fromJson,
  "VersaoAtualizacaoResponseDTO": VersaoAtualizacaoResponseDTO.fromJson,
  "QuestaoCompletaResponseDTO": QuestaoCompletaResponseDTO.fromJson,
  "ProvaDetalhesCadernoQuestaoResponseDTO": ProvaDetalhesCadernoQuestaoResponseDTO.fromJson,
  "ProvaDetalhesCadernoResponseDTO": ProvaDetalhesCadernoResponseDTO.fromJson,
  "QuestaoDetalhesLegadoResponseDTO": QuestaoDetalhesLegadoResponseDTO.fromJson,
});
