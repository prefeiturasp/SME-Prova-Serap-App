import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/idb_file.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'principal.store.g.dart';

class PrincipalStore = _PrincipalStoreBase with _$PrincipalStore;

abstract class _PrincipalStoreBase with Store, Loggable {
  final usuario = GetIt.I.get<UsuarioStore>();

  @observable
  ObservableStream<ConnectivityStatus> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => conexaoStream.value, onChangeConexao);
    await obterVersaoDoApp();
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityStatus status = ConnectivityStatus.wifi;

  @observable
  String versaoApp = "Versão 0";

  @computed
  bool get temConexao => status != ConnectivityStatus.none;

  @computed
  String get versao => "$versaoApp ${status == ConnectivityStatus.none ? ' - Sem conexão' : ''}";

  @action
  Future onChangeConexao(ConnectivityStatus? resultado) async {
    status = resultado!;
  }

  @action
  Future<void> obterVersaoDoApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versaoApp = "Versão ${packageInfo.version}";
  }

  @action
  Future<void> sair() async {
    AppDatabase db = GetIt.I.get();

    try {
      List<ProvaDb> provas = await db.obterProvas();

      if (provas.isNotEmpty) {
        List<int> downlodIds = provas
            .where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO.index)
            .toList()
            .map((element) => element.idDownload!)
            .toList();

        await ServiceLocator.get<ApiService>().download.removerDownloads(downlodIds);
      }
    } catch (e, stack) {
      severe('Erro ao remover downlodas');
      severe(e);
      severe(stack);
    }

    await _limparDadosLocais();
    await _apagarArquivos(db);

    await db.limpar();

    bool eraAdimin = usuario.isAdmin;

    usuario.dispose();

    if (eraAdimin) {
      await launch("https://hom-serap.sme.prefeitura.sp.gov.br/", webOnlyWindowName: '_self');
    }
  }

  _limparDadosLocais() async {
    SharedPreferences prefs = GetIt.I.get();

    info(prefs.getKeys());

    for (var key in prefs.getKeys()) {
      if (!key.startsWith("resposta_")) {
        await prefs.remove(key);
      }
    }
  }

  Future<void> _apagarArquivos(AppDatabase db) async {
    var arquivos = await db.arquivosVideosDao.listarTodos();

    for (var arquivo in arquivos) {
      if (kIsWeb) {
        await IdbFile(arquivo.path).delete();
      } else {
        await apagarArquivo(arquivo.path);
      }
    }
  }
}
