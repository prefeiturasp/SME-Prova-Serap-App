import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tema.store.g.dart';

class TemaStore = _TemaStoreBase with _$TemaStore;

abstract class _TemaStoreBase with Store {
  final aditivoTamanhoFonte = 2;
  final tamanhoMinimoFixo = 12;
  final tamanhoMaximoFixo = 24;

  /// Prefixo `t` se refere ao `tamanho`

  @observable
  double incrementador = 16;

  @observable
  double tTexto12 = 12;

  @observable
  double tTexto14 = 14;

  @observable
  double tTexto16 = 16;

  @observable
  double tTexto18 = 18;

  @observable
  double tTexto20 = 20;

  @observable
  double tTexto24 = 24;

  @action
  void fachadaAlterarTamanhoDoTexto(double valor) {
    incrementador = valor;

    tTexto12 = (incrementador - 4);
    tTexto14 = 2 + (incrementador - 4);
    tTexto16 = 4 + (incrementador - 4);
    tTexto18 = 6 + (incrementador - 4);
    tTexto20 + 8 + (incrementador - 4);
    tTexto24 = 10 + (incrementador - 4);

    print('I $incrementador');
    print('T12 $tTexto12');
    print('T14 $tTexto14');
    print('T16 $tTexto16');
    print('T18 $tTexto18');
    print('T20 $tTexto20');
    print('T24 $tTexto24');
    
  }
}
