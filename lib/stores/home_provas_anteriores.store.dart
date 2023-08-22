import 'package:appserap/dtos/prova_anterior.response.dto.dart';
import 'package:appserap/services/api.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'home_provas_anteriores.store.g.dart';

@LazySingleton()
class HomeProvasAnterioresStore = _HomeProvasAnterioresStoreBase with _$HomeProvasAnterioresStore;

abstract class _HomeProvasAnterioresStoreBase with Store {
  final ProvaService _provaService;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<ProvaAnteriorResponseDTO> provasAnteriores = ObservableList<ProvaAnteriorResponseDTO>();

  _HomeProvasAnterioresStoreBase(
    this._provaService,
  );

  @action
  Future<void> carregarProvasAnteriores() async {
    isLoading = true;

    ObservableList<ProvaAnteriorResponseDTO> _provasAnteriores = <ProvaAnteriorResponseDTO>[].asObservable();

    var response = await _provaService.getProvasAnteriores();

    if (response.isSuccessful) {
      isLoading = false;
      _provasAnteriores = response.body!.asObservable();
    }

    provasAnteriores = _provasAnteriores;
    isLoading = false;
  }
}
