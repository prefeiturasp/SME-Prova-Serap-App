import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/src/response.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'admin_prova_resumo.store.g.dart';

class AdminProvaResumoViewStore = _AdminProvaResumoViewStoreBase with _$AdminProvaResumoViewStore;

abstract class _AdminProvaResumoViewStoreBase with Store, Loggable {
  @observable
  bool carregando = false;

  @observable
  ObservableList<AdminProvaResumoResponseDTO> resumo = ObservableList<AdminProvaResumoResponseDTO>();

  @action
  carregarResumo(int idProva, {String? caderno}) async {
    carregando = true;
    await retry(
      () async {
        Response<List<AdminProvaResumoResponseDTO>> res;
        if (caderno != null) {
          res = await ServiceLocator.get<ApiService>().admin.getResumoByCaderno(idProva: idProva, caderno: caderno);
        } else {
          res = await ServiceLocator.get<ApiService>().admin.getResumo(idProva: idProva);
        }

        if (res.isSuccessful) {
          resumo = res.body!.asObservable();
        }
      },
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento Resumo Prova - ${e.toString()}');
      },
    );

    carregando = false;
  }
}
