import 'package:appserap/services/autenticacao.service.dart';
import 'package:appserap/services/prova.service.dart';
import 'package:appserap/services/usuario.service.dart';
import 'package:appserap/services/versao.service.dart';
import 'package:appserap/stores/autenticacao.store.dart';
import 'package:appserap/stores/autenticacao_erro.store.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova_atual.store.dart';
import 'package:appserap/stores/provas.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:get_it/get_it.dart';

class DependenciasIoC {
  late GetIt getIt;

  DependenciasIoC() {
    getIt = GetIt.instance;
  }

  registrar() {
    getIt.registerSingleton<UsuarioStore>(UsuarioStore());

    getIt.registerSingleton<ApiUtil>(ApiUtil());
    getIt.registerSingleton<VersaoService>(VersaoService());

    getIt.registerSingleton<UsuarioService>(UsuarioService());
    getIt.registerSingleton<AutenticacaoService>(AutenticacaoService());
    getIt.registerSingleton<PrincipalStore>(PrincipalStore());
    getIt.registerSingleton<AutenticacaoErroStore>(AutenticacaoErroStore());
    getIt.registerSingleton<AutenticacaoStore>(AutenticacaoStore());

    getIt.registerSingleton<ProvaService>(ProvaService());
    getIt.registerSingleton<ProvasStore>(ProvasStore());
    getIt.registerSingleton<ProvaAtualStore>(ProvaAtualStore());
    getIt.registerSingleton<HomeStore>(HomeStore());
  }
}
