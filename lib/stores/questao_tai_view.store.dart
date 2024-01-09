import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/dtos/questao_completa.tai.response.dto.dart';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/enums/request_status.enum.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'questao_tai_view.store.g.dart';

@LazySingleton()
class QuestaoTaiViewStore = _QuestaoTaiViewStoreBase with _$QuestaoTaiViewStore;

abstract class _QuestaoTaiViewStoreBase with Store, Loggable {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;

  final ProvaTaiService _provaTaiService;
  final PrincipalStore _principalStore;
  final UsuarioStore _usuarioStore;

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

  DateTime? dataHoraInicioQuestao;
  DateTime? dataHoraFimQuestao;

  _QuestaoTaiViewStoreBase(
    this.db,
    this.dbRespostas,
    this._provaTaiService,
    this._principalStore,
    this._usuarioStore,
  );

  @action
  Future carregarQuestao(int provaId) async {
    carregando = true;

    alternativaIdMarcada = null;
    dataHoraInicioQuestao = null;
    dataHoraFimQuestao = null;

    if (provaStore == null || provaStore?.id != provaId) {
      var prova = await db.provaDao.obterPorProvaId(provaId);

      provaStore = ProvaStore(prova: prova);
      provaStore!.tratamentoImagem = TratamentoImagemEnum.URL;
    }

    try {
      var responseConexao = await _provaTaiService.existeConexaoR();

      if (responseConexao.isSuccessful) {
        taiDisponivel = responseConexao.body!;

        await retry(
          () async {
            Response<QuestaoCompletaTaiResponseDTO>? response = await _provaTaiService.obterQuestao(
              provaId: provaId,
            );

            if (response.isSuccessful) {
              questao = response.body!;

              // Tempo de inicio da questao
              dataHoraInicioQuestao = DateTime.now();
            }
          },
          onRetry: (e) {
            fine('[Prova $provaId] - Tentativa de carregamento da Questao ordem ${questao!.ordem} - ${e.toString()}');
          },
        );
      } else {
        taiDisponivel = false;
      }
    } on Exception catch (exception, stack) {
      taiDisponivel = false;
      await recordError(exception, stack, reason: 'Erro ao obter questão da prova TAI');
    }

    await WakelockPlus.enable();

    carregando = false;
  }

  @action
  Future<QuestaoTaiStatusEnum> enviarResposta() async {
    try {
      dataHoraFimQuestao = DateTime.now();

      QuestaoRespostaDTO questaoResposta = QuestaoRespostaDTO(
        alunoRa: _usuarioStore.codigoEOL!,
        dispositivoId: _principalStore.dispositivoId,
        questaoId: questao!.id,
        alternativaId: alternativaIdMarcada,
        resposta: textoRespondido,
        dataHoraRespostaTicks: getTicks(dataHoraResposta!),
        tempoRespostaAluno: dataHoraFimQuestao!.difference(dataHoraInicioQuestao!).inSeconds,
      );

      var response = await _provaTaiService.proximaQuestao(
        provaId: provaStore!.id,
        resposta: questaoResposta,
      );

      if (response.isSuccessful) {
        if (response.body!) {
          dataHoraInicioQuestao = null;
          dataHoraFimQuestao = null;

          return QuestaoTaiStatusEnum.CONTINUAR;
        } else {
          return QuestaoTaiStatusEnum.RESUMO;
        }
      }
    } catch (exception, stack) {
      await recordError(exception, stack, reason: 'Erro ao enviar resposta da questão TAI');

      return QuestaoTaiStatusEnum.ERRO;
    }

    return QuestaoTaiStatusEnum.ERRO;
  }
}
