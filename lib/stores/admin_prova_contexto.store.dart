import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api_service.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'admin_prova_contexto.store.g.dart';

class AdminProvaContextoViewStore = _AdminProvaContextoViewStoreBase with _$AdminProvaContextoViewStore;

abstract class _AdminProvaContextoViewStoreBase with Store, Loggable {
  @observable
  bool carregando = false;

  @observable
  ObservableList<ContextoProvaResponseDTO> contextosProva = ObservableList<ContextoProvaResponseDTO>();

  @action
  carregarContexto(int idProva) async {
    carregando = true;
    await retry(
      () async {
        var res = await ServiceLocator.get<ApiService>().contextoProva.getContextosPorProva(idProva: idProva);

        if (res.isSuccessful) {
          contextosProva = res.body!.asObservable();
        } else {
          severe(res.base);
          severe(res.error);
        }
      },
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento lista de cadernos - ${e.toString()}');
      },
    );
    carregando = false;
  }
}
