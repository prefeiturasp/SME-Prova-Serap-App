import 'package:mobx/mobx.dart';

part 'autenticacao_erro.store.g.dart';

class AutenticacaoErroStore = _AutenticacaoErroStoreBase with _$AutenticacaoErroStore;

abstract class _AutenticacaoErroStoreBase with Store {
  @observable
  String? codigoEOL;

  @observable
  String? senha;

  @computed
  bool get possuiErros => codigoEOL != null || senha != null;
}
