import 'package:appserap/database/app.database.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:chopper/src/response.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

    ConnectivityResult resultado = await (Connectivity().checkConnectivity());
    if (resultado != ConnectivityResult.none) {
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
              ProvaStore provaLocal = provasStore[prova.id]!;

              // Data alteração da prova alterada
              if (!isSameDates(provaStore.prova.ultimaAlteracao, provaLocal.prova.ultimaAlteracao)) {
                if (provaStore.prova.status != EnumProvaStatus.INICIADA &&
                    provaStore.prova.status != EnumProvaStatus.FINALIZADA &&
                    provaStore.prova.status != EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE) {
                  // remover download
                  await removerProva(provaStore);
                }
              } else if (provaLocal.prova.caderno != provaStore.prova.caderno) {
                info(
                    "[Prova ${provaStore.id}] - Caderno alterado ${provaLocal.prova.caderno} -> ${provaStore.prova.caderno}");
                await removerProva(provaStore, true);
              } else {
                provaStore.downloadStatus = provaLocal.downloadStatus;
                provaStore.prova.downloadStatus = provaLocal.downloadStatus;

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
      } catch (e, stack) {
        await recordError(e, stack);
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

  @action
  removerProva(ProvaStore provaStore, [bool manterRegistroProva = false]) async {
    await provaStore.removerDownload(manterRegistroProva);

    provaStore.downloadStatus = EnumDownloadStatus.ATUALIZAR;
    provaStore.prova.downloadStatus = EnumDownloadStatus.ATUALIZAR;
  }

  Future<void> carregaProva(int idProva, ProvaStore provaStoreAtualizada) async {
    var provaDao = ServiceLocator.get<AppDatabase>().provaDao;

    Prova? prova = await provaDao.obterPorIdNull(idProva);

    if (prova != null) {
      // atualizar prova com os valores remotos

      prova.status = provaStoreAtualizada.prova.status;
      prova.downloadStatus = provaStoreAtualizada.prova.downloadStatus;

      prova.dataInicioProvaAluno = provaStoreAtualizada.prova.dataInicioProvaAluno;
      prova.dataFimProvaAluno = provaStoreAtualizada.prova.dataFimProvaAluno;

      prova.dataInicio = provaStoreAtualizada.prova.dataInicio;
      prova.dataFim = provaStoreAtualizada.prova.dataFim;

      prova.ultimaAlteracao = provaStoreAtualizada.prova.ultimaAlteracao;

      prova.tempoAlerta = provaStoreAtualizada.prova.tempoAlerta;
      prova.tempoExecucao = provaStoreAtualizada.prova.tempoExecucao;
      prova.tempoExtra = provaStoreAtualizada.prova.tempoExtra;

      prova.itensQuantidade = provaStoreAtualizada.prova.itensQuantidade;
      prova.quantidadeRespostaSincronizacao = provaStoreAtualizada.prova.quantidadeRespostaSincronizacao;
      prova.senha = provaStoreAtualizada.prova.senha;
      prova.caderno = provaStoreAtualizada.prova.caderno;

      provaStoreAtualizada.prova = prova;
      provaStoreAtualizada.downloadStatus = prova.downloadStatus;
    }

    await provaDao.inserirOuAtualizar(provaStoreAtualizada.prova);

    if (provaStoreAtualizada.downloadStatus == EnumDownloadStatus.ATUALIZAR) {
      info('Prova ${provaStoreAtualizada.id} alterada. Iniciando atualização');
      provaStoreAtualizada.iniciarDownload();
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
