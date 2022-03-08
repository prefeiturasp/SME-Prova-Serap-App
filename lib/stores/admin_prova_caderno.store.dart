import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api_service.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';

import '../main.ioc.dart';
part 'admin_prova_caderno.store.g.dart';

class AdminProvaCadernoViewStore = _AdminProvaCadernoViewStoreBase with _$AdminProvaCadernoViewStore;

abstract class _AdminProvaCadernoViewStoreBase with Store, Loggable {
  @observable
  bool carregando = false;

  @observable
  ObservableList<String> cadernos = ObservableList<String>();

  @action
  carregarCadernos(int idProva) async {
    carregando = true;
    await retry(
      () async {
        var res = await ServiceLocator.get<ApiService>().admin.getCadernos(idProva: idProva);

        if (res.isSuccessful) {
          cadernos = res.body!.cadernos.asObservable();
        }
      },
      retryIf: (e) => e is Exception,
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento lista de cadernos ');
      },
    );
    carregando = false;
  }
}
