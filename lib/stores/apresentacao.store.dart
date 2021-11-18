import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:mobx/mobx.dart';

part 'apresentacao.store.g.dart';

class ApresentacaoStore = _ApresentacaoStoreBase with _$ApresentacaoStore;

abstract class _ApresentacaoStoreBase with Store, Loggable {

  @observable
  int pagina = 0;

  void dispose() {
    pagina = 0;
  }
}
