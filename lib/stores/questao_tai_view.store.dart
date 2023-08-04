import 'package:appserap/dtos/questao_completa.tai.response.dto.dart';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:chopper/chopper.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'questao_tai_view.store.g.dart';

class QuestaoTaiViewStore = _QuestaoTaiViewStoreBase with _$QuestaoTaiViewStore;

abstract class _QuestaoTaiViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  bool taiDisponivel = false;

  @observable
  ProvaStore? provaStore;

  @observable
  QuestaoCompletaTaiResponseDTO? questao;

  @observable
  int? alternativaIdMarcada;

  @observable
  String? textoRespondido;

  @observable
  DateTime? dataHoraResposta;

  @observable
  bool botaoFinalizarOcupado = false;

  @action
  Future carregarQuestao(int provaId) async {
    carregando = true;

    alternativaIdMarcada = null;

    if (provaStore == null) {
      var prova = await db.provaDao.obterPorProvaId(provaId);

      provaStore = ProvaStore(prova: prova);
      provaStore!.tratamentoImagem = TratamentoImagemEnum.URL;
    }

    var responseConexao = await ServiceLocator.get<ApiService>().provaTai.existeConexaoR();

    if (responseConexao.isSuccessful) {
      taiDisponivel = responseConexao.body!;

      await retry(
        () async {
          Response<QuestaoCompletaTaiResponseDTO>? response =
              await ServiceLocator.get<ApiService>().provaTai.obterQuestao(
                    provaId: provaId,
                  );

          if (response.isSuccessful) {
            questao = response.body!;
          }
        },
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de carregamento da Questao ordem ${questao!.ordem} - ${e.toString()}');
        },
      );
    } else {
      taiDisponivel = false;
    }

    await WakelockPlus.enable();

    carregando = false;
  }

  @action
  Future<bool> enviarResposta() async {
    var principalStore = ServiceLocator.get<PrincipalStore>();
    var usuarioStore = ServiceLocator.get<UsuarioStore>();

    QuestaoRespostaDTO questaoResposta = QuestaoRespostaDTO(
      alunoRa: usuarioStore.codigoEOL!,
      dispositivoId: principalStore.dispositivoId,
      questaoId: questao!.id,
      alternativaId: alternativaIdMarcada,
      resposta: textoRespondido,
      dataHoraRespostaTicks: getTicks(dataHoraResposta!),
      tempoRespostaAluno: 0,
    );

    var response = await ServiceLocator.get<ApiService>().provaTai.proximaQuestao(
          provaId: provaStore!.id,
          resposta: questaoResposta,
        );

    if (response.isSuccessful) {
      return response.body!;
    }

    return false;
  }
}
