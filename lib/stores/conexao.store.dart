import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';

part 'conexao.store.g.dart';

class ConexaoStore = _ConexaoStoreBase with _$ConexaoStore;

abstract class _ConexaoStoreBase with Store {
  @observable
  ObservableStream<ConnectivityResult> connectivityStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  void setupReactions() {
    _disposer = reaction((_) => connectivityStream.value, (result) => validarConexao(result));
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

  @action
  // ignore: avoid_void_async
  Future validarConexao(Object? resultado) async {
    status = resultado as ConnectivityResult;
  }

  void dispose() {
    _disposer!();
  }
}
