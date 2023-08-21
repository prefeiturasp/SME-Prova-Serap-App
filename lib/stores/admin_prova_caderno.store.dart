import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';

part 'admin_prova_caderno.store.g.dart';

@LazySingleton()
class AdminProvaCadernoViewStore = _AdminProvaCadernoViewStoreBase with _$AdminProvaCadernoViewStore;

abstract class _AdminProvaCadernoViewStoreBase with Store, Loggable {
  final AdminService _adminService;

  @observable
  bool carregando = false;

  @observable
  ObservableList<String> cadernos = ObservableList<String>();

  _AdminProvaCadernoViewStoreBase(this._adminService,);

  @action
  carregarCadernos(int idProva) async {
    carregando = true;
    await retry(
      () async {
        var res = await _adminService.getCadernos(idProva: idProva);

        if (res.isSuccessful) {
          cadernos = res.body!.cadernos.asObservable();
        }
      },
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento lista de cadernos - ${e.toString()}');
      },
    );
    carregando = false;
  }
}
