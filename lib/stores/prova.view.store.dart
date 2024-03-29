import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

@LazySingleton()
class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  ProvaStore? provaStore;

  bool botaoOcupado = false;

  @observable
  bool isLoading = true;

  setup(ProvaStore provaStore) {
    this.provaStore = provaStore;
  }

  void dispose() {}
}
