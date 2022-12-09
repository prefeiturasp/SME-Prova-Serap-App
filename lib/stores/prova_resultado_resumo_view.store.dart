import 'package:appserap/dtos/prova_resultado_resumo.response.dto.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/chopper.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'prova_resultado_resumo_view.store.g.dart';

class ProvaResultadoResumoViewStore = _ProvaResultadoResumoViewStoreBase with _$ProvaResultadoResumoViewStore;

abstract class _ProvaResultadoResumoViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  ProvaResultadoResumoResponseDto? response;

  @observable
  Prova? prova;

  @action
  carregarResumo({required int provaId, required String caderno}) async {
    carregando = true;
    await retry(
      () async {
        prova = await db.provaDao.obterPorProvaIdECaderno(provaId, caderno);

        Response<ProvaResultadoResumoResponseDto> res =
            await ServiceLocator.get<ApiService>().provaResultado.getResumoPorProvaId(
                  provaId: provaId,
                );

        if (res.isSuccessful) {
          response = res.body!;
        }
      },
      onRetry: (e) {
        fine('[Prova $provaId] - Tentativa de carregamento Resumo Prova - ${e.toString()}');
      },
    );

    carregando = false;
  }
}
