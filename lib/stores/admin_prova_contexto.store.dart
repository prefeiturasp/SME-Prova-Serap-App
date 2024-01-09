import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'admin_prova_contexto.store.g.dart';

@LazySingleton()
class AdminProvaContextoViewStore = _AdminProvaContextoViewStoreBase with _$AdminProvaContextoViewStore;

abstract class _AdminProvaContextoViewStoreBase with Store, Loggable {
  final ContextoProvaService _contextoProvaService;

  @observable
  bool carregando = false;

  @observable
  ObservableList<ContextoProvaResponseDTO> contextosProva = ObservableList<ContextoProvaResponseDTO>();

  _AdminProvaContextoViewStoreBase(this._contextoProvaService,);

  @action
  carregarContexto(int idProva) async {
    carregando = true;
    await retry(
      () async {
        var res = await _contextoProvaService.getContextosPorProva(idProva: idProva);

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
