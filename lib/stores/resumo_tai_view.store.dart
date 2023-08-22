import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/dtos/prova_resumo_tai.response.dto.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'resumo_tai_view.store.g.dart';

@LazySingleton()
class ResumoTaiViewStore = _ResumoTaiViewStoreBase with _$ResumoTaiViewStore;

abstract class _ResumoTaiViewStoreBase with Store, Loggable {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;

  final ProvaTaiService _provaTaiService;

  @observable
  bool carregando = false;

  @observable
  ProvaStore? provaStore;

  @observable
  bool botaoFinalizarOcupado = false;

  @observable
  ObservableList<ProvaResumoTaiResponseDto>? resumo;

  _ResumoTaiViewStoreBase(
    this.db,
    this.dbRespostas,
    this._provaTaiService,
  );

  @action
  Future<void> carregarResumo(int provaId) async {
    carregando = true;

    if (provaStore == null) {
      var prova = await db.provaDao.obterPorProvaId(provaId);
      provaStore = ProvaStore(prova: prova);
    }

    await retry(
      () async {
        var response = await _provaTaiService.obterResumo(provaId: provaId);

        if (response.isSuccessful) {
          resumo = response.body!.asObservable();
        }
      },
      onRetry: (e) {
        fine('[Prova $provaId] - Tentativa de carregamento do resumo da prova - ${e.toString()}');
      },
    );

    carregando = false;
  }

  @action
  Future<void> finalizarProva() async {
    await provaStore!.setStatusProva(EnumProvaStatus.FINALIZADA);
    await provaStore!.setHoraFimProva(DateTime.now());

    await _provaTaiService.finalizarProva(
      provaId: provaStore!.id,
      status: EnumProvaStatus.INICIADA.index,
      tipoDispositivo: kDeviceType.index,
      dataInicio: getTicks(provaStore!.prova.dataInicioProvaAluno!),
      dataFim: getTicks(provaStore!.prova.dataFimProvaAluno!),
    );
  }
}
