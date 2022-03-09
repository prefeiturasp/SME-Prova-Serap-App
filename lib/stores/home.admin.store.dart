import 'package:appserap/dtos/admin_prova.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'home.admin.store.g.dart';

class HomeAdminStore = _HomeAdminStoreBase with _$HomeAdminStore;

abstract class _HomeAdminStoreBase with Store, Loggable {
  @observable
  bool carregando = false;

  @observable
  String codigoIniciarProva = "";

  @observable
  String desricao = "";

  @observable
  ObservableList<AdminProvaResponseDTO> provas = ObservableList<AdminProvaResponseDTO>();

  @action
  carregarProvas() async {
    carregando = true;

    await retry(
      () async {
        var provasResponse = await ServiceLocator.get<ApiService>().admin.getProvas(
              descricao: desricao,
            );

        if (provasResponse.isSuccessful) {
          var provas = provasResponse.body;

          this.provas = ObservableList.of(provas!.items);
        }
      },
      retryIf: (e) => e is Exception,
      onRetry: (e) {
        fine('Tentativa de carregamento lista de provas ');
      },
    );

    carregando = false;
  }
}
