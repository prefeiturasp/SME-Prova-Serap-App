import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  late ProvaStore provaStore;

  bool botaoOcupado = false;

  @observable
  bool isLoading = true;

  setup(ProvaStore provaStore) async {
    this.provaStore = provaStore;
    await configurarProva();
  }

  configurarProva() async {
    if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA) {
      await provaStore.iniciarProva();
    } else {
      await provaStore.continuarProva();
    }
  }

  void dispose() {
  }
}
