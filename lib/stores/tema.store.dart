import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/services/api.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'tema.store.g.dart';

@LazySingleton()
class TemaStore = _TemaStoreBase with _$TemaStore;

abstract class _TemaStoreBase with Store {
  final UsuarioService _usuarioService;

  /// Prefixo `t` se refere ao `tamanho`

  @observable
  double incrementador = 16;

  @observable
  double tTexto10 = 10;

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

  @observable
  double appbarHeight = 78;

  _TemaStoreBase(
    this._usuarioService,
  );

  double size(double size) {
    if (size == 10) {
      return tTexto10;
    }
    if (size == 12) {
      return tTexto12;
    }
    if (size == 14) {
      return tTexto14;
    }
    if (size == 16) {
      return tTexto16;
    }
    if (size == 18) {
      return tTexto18;
    }
    if (size == 20) {
      return tTexto20;
    }
    if (size == 24) {
      return tTexto24;
    }

    return size;
  }

  @observable
  FonteTipoEnum fonteDoTexto = FonteTipoEnum.POPPINS;

  @action
  void fachadaAlterarTamanhoDoTexto(double valor, {bool update = true}) {
    incrementador = valor;

    tTexto12 = 2 - (incrementador - 4);
    tTexto12 = (incrementador - 4);
    tTexto14 = 2 + (incrementador - 4);
    tTexto16 = 4 + (incrementador - 4);
    tTexto18 = 6 + (incrementador - 4);
    tTexto20 = 8 + (incrementador - 4);
    tTexto24 = 10 + (incrementador - 4);

    if (incrementador >= 24) {
      appbarHeight = 128;
    } else if (incrementador >= 22) {
      appbarHeight = 120;
    } else if (incrementador >= 20) {
      appbarHeight = 108;
    } else if (incrementador >= 18) {
      appbarHeight = 98;
    } else {
      appbarHeight = 78;
    }

    if (update) {
      enviarPreferencias();
    }
  }

  @action
  void mudarFonte(FonteTipoEnum fonte, {bool update = true}) {
    fonteDoTexto = fonte;

    if (update) {
      enviarPreferencias();
    }
  }

  void enviarPreferencias() {
    _usuarioService.atualizarPreferencias(
      tamanhoFonte: incrementador.toInt(),
      familiaFonte: fonteDoTexto.index,
    );
  }
}
