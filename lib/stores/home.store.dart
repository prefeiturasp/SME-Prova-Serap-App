import 'package:appserap/database/app.database.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:chopper/src/response.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store, Loggable, Disposable {
  @observable
  ObservableMap<int, ProvaStore> provas = ObservableMap<int, ProvaStore>();

  @observable
  bool carregando = false;

  @action
  carregarProvas() async {
    carregando = true;
    String codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL!;

    Map<int, ProvaStore> provasStore = {};

    AppDatabase db = GetIt.I.get();

    List<Prova> provasDb = await db.provaDao.listarTodosPorAluno(codigoEOL);
    for (var prova in provasDb) {
      provasStore[prova.id] = ProvaStore(
        id: prova.id,
        prova: prova,
      );
    }

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());

    // Atualizar lista de provas do cache
    if (resultado != ConnectivityStatus.none) {
      try {
        Response<List<ProvaResponseDTO>> response = await GetIt.I.get<ApiService>().prova.getProvas();

        if (response.isSuccessful) {
          var provasResponse = response.body!;

          await db.provaAlunoDao.apagarPorUsuario(codigoEOL);

          for (var provaResponse in provasResponse) {
            await db.provaAlunoDao.inserirOuAtualizar(ProvaAluno(
              codigoEOL: codigoEOL,
              provaId: provaResponse.id,
            ));

            var prova = provaResponse.toProvaModel();

            var provaStore = ProvaStore(
              id: provaResponse.id,
              prova: prova,
            );

            // caso nao tenha o id, define como nova prova
            if (!provasStore.keys.contains(provaStore.id)) {
              provaStore.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
              provaStore.prova.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
            } else {
              // Data alteração da prova alterada
              if (!isSameDates(provaStore.prova.ultimaAlteracao, provasStore[prova.id]!.prova.ultimaAlteracao)) {
                if (provaStore.prova.status != EnumProvaStatus.INICIADA) {
                  // remover download
                  await provaStore.removerDownload();

                  provaStore.downloadStatus = EnumDownloadStatus.ATUALIZAR;
                  provaStore.prova.downloadStatus = EnumDownloadStatus.ATUALIZAR;
                }
              } else {
                provaStore.downloadStatus = EnumDownloadStatus.CONCLUIDO;
                provaStore.prova.downloadStatus = EnumDownloadStatus.CONCLUIDO;

                var provaLocal = provasStore[prova.id]!;
                if (provaLocal.status != EnumProvaStatus.PENDENTE) {
                  provaStore.status = prova.status;
                } else {
                  provaStore.status = provaLocal.status;
                  prova.status = provaLocal.status;
                }
              }
            }

            provasStore[provaStore.id] = provaStore;
          }

          var idsRemote = provasResponse.map((e) => e.id).toList();

          provasStore.removeWhere((idProva, prova) => !idsRemote.contains(idProva));
        }
      } catch (e, stacktrace) {
        severe(e);
        severe(stacktrace);
      }
    }

    if (provasStore.isNotEmpty) {
      var mapEntries = provasStore.entries.toList()
        ..sort((a, b) => a.value.prova.dataInicio.compareTo(b.value.prova.dataInicio));

      provasStore
        ..clear()
        ..addEntries(mapEntries);

      for (var provaStore in provasStore.values) {
        await carregaProva(provaStore.id, provaStore);
        provaStore.configure();
      }
    }
    provas = ObservableMap.of(provasStore);

    carregando = false;
  }

  Future<void> carregaProva(int idProva, ProvaStore provaStore) async {
    var provaDao = ServiceLocator.get<AppDatabase>().provaDao;

    Prova? prova = await provaDao.obterPorIdNull(idProva);

    if (prova != null) {
      // atualizar prova com os valores remotos

      prova.status = provaStore.prova.status;
      prova.dataInicioProvaAluno = provaStore.prova.dataInicioProvaAluno;
      prova.dataFimProvaAluno = provaStore.prova.dataFimProvaAluno;

      prova.dataInicio = provaStore.prova.dataInicio;
      prova.dataFim = provaStore.prova.dataFim;

      prova.ultimaAlteracao = provaStore.prova.ultimaAlteracao;

      prova.tempoAlerta = provaStore.prova.tempoAlerta;
      prova.tempoExecucao = provaStore.prova.tempoExecucao;
      prova.tempoExtra = provaStore.prova.tempoExtra;

      prova.itensQuantidade = provaStore.prova.itensQuantidade;
      prova.quantidadeRespostaSincronizacao = provaStore.prova.quantidadeRespostaSincronizacao;
      prova.senha = provaStore.prova.senha;

      provaStore.prova = prova;
      provaStore.downloadStatus = prova.downloadStatus;
    }

    await provaDao.inserirOuAtualizar(provaStore.prova);

    if (provaStore.downloadStatus == EnumDownloadStatus.ATUALIZAR) {
      info('Prova alterada. Iniciando atualização');
      provaStore.iniciarDownload();
    }
  }

  @override
  onDispose() {
    limpar();
    cancelarTimers();
  }

  @action
  cancelarTimers() {
    for (var prova in provas.values) {
      prova.onDispose();
    }
  }

  @action
  limpar() {
    provas = <int, ProvaStore>{}.asObservable();
  }
}
