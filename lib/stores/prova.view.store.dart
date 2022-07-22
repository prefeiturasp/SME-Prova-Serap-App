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

  setup(ProvaStore provaStore) {
    this.provaStore = provaStore;
  }

  void dispose() {
    provaStore.onDispose();
  }
}
