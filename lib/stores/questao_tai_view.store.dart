import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:chopper/chopper.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';

part 'questao_tai_view.store.g.dart';

class QuestaoTaiViewStore = _QuestaoTaiViewStoreBase with _$QuestaoTaiViewStore;

abstract class _QuestaoTaiViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  ProvaStore? provaStore;

  @observable
  QuestaoCompletaResponseDTO? response;

  @action
  Future carregarQuestao(int provaId) async {
    carregando = true;

    if (response == null) {
      await retry(
        () async {
          Response<QuestaoCompletaResponseDTO>? res;

          res = await ServiceLocator.get<ApiService>().provaTai.obterQuestao(provaId: provaId);

          if (res.isSuccessful) {
            response = res.body!;
          }
        },
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de carregamento da Questao ordem ${response!.ordem} - ${e.toString()}');
        },
      );
    }

    if (provaStore == null) {
      var prova = await db.provaDao.obterPorProvaId(provaId);

      provaStore = ProvaStore(prova: prova);
    }

    carregando = false;
  }
}
