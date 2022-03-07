import 'package:appserap/dtos/prova.admin.response.dto.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:mobx/mobx.dart';
part 'home.admin.store.g.dart';

class HomeAdminStore = _HomeAdminStoreBase with _$HomeAdminStore;

abstract class _HomeAdminStoreBase with Store {
  @observable
  bool carregando = false;

  @observable
  String codigoIniciarProva = "";

  @observable
  ObservableList<ProvaAdminResponseDTO> provas = ObservableList<ProvaAdminResponseDTO>();

  @action
  carregarProvas() async {
    carregando = true;
    var provasResponse = await ServiceLocator.get<ApiService>().admin.getProvas();

    if (provasResponse.isSuccessful) {
      var provas = provasResponse.body;

      this.provas = ObservableList.of(provas!.items);
    }

    carregando = false;
  }
}
