import 'package:appserap/repositories/usuario.repository.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/view-models/autenticar.viewmodel.dart';
import 'package:get_it/get_it.dart';

class AutenticacaoController {
  final _usuarioRepository = GetIt.I.get<UsuarioRepository>();
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  Future<bool> autenticar(AutenticarViewModel viewModel) async {
    viewModel.carregando = true;
    var token = await _usuarioRepository.autenticar(viewModel);
    if (token.token != "") {
      _usuarioStore.token = token.token;
      var meusDados = await _usuarioRepository.obterDados();
      if (meusDados.nome != "") {
        _usuarioStore.atualizarDados(meusDados.nome, viewModel.codigoEOL, token.token, meusDados.ano);
      }
      viewModel.carregando = false;
      return true;
    }
    viewModel.carregando = false;
    return false;
  }

  Future<void> revalidarToken() async {
    var token = await _usuarioRepository.revalidarToken(_usuarioStore.token);
    if (token != "") {
      _usuarioStore.token = token;
    }
  }
}
