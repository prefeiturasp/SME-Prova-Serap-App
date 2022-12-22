import 'package:appserap/dtos/prova_resumo_tai.response.dto.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'resumo_tai_view.store.g.dart';

class ResumoTaiViewStore = _ResumoTaiViewStoreBase with _$ResumoTaiViewStore;

abstract class _ResumoTaiViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  ProvaStore? provaStore;

  @observable
  bool botaoFinalizarOcupado = false;

  @observable
  ObservableList<ProvaResumoTaiResponseDto>? resumo;

  @action
  Future<void> carregarResumo(int provaId) async {
    carregando = true;

    if (provaStore == null) {
      var prova = await db.provaDao.obterPorProvaId(provaId);
      provaStore = ProvaStore(prova: prova);
    }

    if (resumo == null) {
      await retry(
        () async {
          var response = await ServiceLocator.get<ApiService>().provaTai.obterResumo(provaId: provaId);

          if (response.isSuccessful) {
            resumo = response.body!.asObservable();
          }
        },
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de carregamento do resumo da prova - ${e.toString()}');
        },
      );
    }

    carregando = false;
  }

  @action
  Future<void> finalizarProva() async {
    await provaStore!.setStatusProva(EnumProvaStatus.FINALIZADA);
    await provaStore!.setHoraFimProva(DateTime.now());

    await ServiceLocator.get<ApiService>().provaTai.finalizarProva(
          provaId: provaStore!.id,
          status: EnumProvaStatus.INICIADA.index,
          tipoDispositivo: kDeviceType.index,
          dataInicio: getTicks(provaStore!.prova.dataInicioProvaAluno!),
          dataFim: getTicks(provaStore!.prova.dataFimProvaAluno!),
        );
  }
}
