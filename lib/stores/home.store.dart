import 'package:appserap/database/app.database.dart';
import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:chopper/src/response.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';

import 'principal.store.dart';

part 'home.store.g.dart';

@LazySingleton()
class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store, Loggable {
  final UsuarioStore _usuarioStore;
  final PrincipalStore _principalStore;
  final AppDatabase db;
  final ProvaService _provaService;

  @observable
  ObservableMap<int, ProvaStore> provas = ObservableMap<int, ProvaStore>();

  @observable
  bool carregando = false;

  _HomeStoreBase(
    this._usuarioStore,
    this._principalStore,
    this.db,
    this._provaService,
  );

  @action
  carregarProvas() async {
    carregando = true;
    String codigoEOL = _usuarioStore.codigoEOL!;

    Map<int, ProvaStore> provasStore = {};

    List<Prova> provasDb = await db.provaDao.listarTodosPorAluno(codigoEOL);
    for (var prova in provasDb) {
      provasStore[prova.id] = ProvaStore(
        prova: prova,
      );
    }

    if (_principalStore.temConexao) {
      try {
        Response<List<ProvaResponseDTO>> response = await _provaService.getProvas();

        if (response.isSuccessful) {
          var provasResponse = response.body!;

          await db.provaAlunoDao.apagarPorUsuario(codigoEOL);

          for (var provaResponse in provasResponse) {
            await db.provaAlunoDao.inserirOuAtualizar(ProvaAluno(
              codigoEOL: codigoEOL,
              provaId: provaResponse.id,
            ));

            var prova = provaResponse.toProvaModel();

            var provaRemotaStore = ProvaStore(
              prova: provaResponse.toProvaModel(),
            );

            // caso nao tenha o id, define como nova prova
            var provaLocalExiste = await db.provaDao.existeProva(provaResponse.id, provaResponse.caderno);

            if (provaLocalExiste == null) {
              provaRemotaStore.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
              provaRemotaStore.prova.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
            } else {
              ProvaStore? provaLocal = ProvaStore(
                prova: provaLocalExiste,
              );

              // Data alteração da prova alterada
              if (!isSameDates(provaRemotaStore.prova.ultimaAlteracao, provaLocal.prova.ultimaAlteracao)) {
                if (provaRemotaStore.prova.status != EnumProvaStatus.INICIADA &&
                    provaRemotaStore.prova.status != EnumProvaStatus.FINALIZADA &&
                    provaRemotaStore.prova.status != EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_JOB &&
                    provaRemotaStore.prova.status != EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_TEMPO &&
                    provaRemotaStore.prova.status != EnumProvaStatus.FINALIZADA_OFFLINE) {
                  // remover download
                  await removerProva(provaRemotaStore);
                }
              } else {
                provaRemotaStore.downloadStatus = provaLocal.downloadStatus;
                provaRemotaStore.prova.downloadStatus = provaLocal.downloadStatus;

                if (provaLocal.status != EnumProvaStatus.PENDENTE) {
                  provaRemotaStore.status = prova.status;
                } else {
                  provaRemotaStore.status = provaLocal.status;
                  provaRemotaStore.prova.status = provaLocal.status;
                }
              }
            }

            provasStore[provaRemotaStore.id] = provaRemotaStore;
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
        await carregaProva(provaStore.id, provaStore.caderno, provaStore);
        provaStore.configure();
      }
    }

    provas = ObservableMap.of(provasStore);

    carregando = false;
  }

  @action
  Future<void> removerProva(ProvaStore provaStore, [bool manterRegistroProva = false]) async {
    await provaStore.removerDownload(manterRegistroProva);

    provaStore.downloadStatus = EnumDownloadStatus.ATUALIZAR;
    provaStore.prova.downloadStatus = EnumDownloadStatus.ATUALIZAR;
  }

  Future<void> carregaProva(int idProva, String caderno, ProvaStore provaStoreAtualizada) async {
    var provaDao = db.provaDao;

    Prova? prova = await provaDao.obterPorIdNull(idProva, caderno);

    if (prova != null) {
      // atualizar prova com os valores remotos

      prova.downloadStatus = provaStoreAtualizada.prova.downloadStatus;

      if (prova.status == EnumProvaStatus.PENDENTE) {
        provaStoreAtualizada.prova.status = prova.status;
        provaStoreAtualizada.prova.dataInicioProvaAluno = prova.dataInicioProvaAluno;
        provaStoreAtualizada.prova.dataFimProvaAluno = prova.dataFimProvaAluno;
      } else {
        prova.status = provaStoreAtualizada.prova.status;
        prova.dataInicioProvaAluno = provaStoreAtualizada.prova.dataInicioProvaAluno;
        prova.dataFimProvaAluno = provaStoreAtualizada.prova.dataFimProvaAluno;
      }

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

      prova.apresentarResultados = provaStoreAtualizada.prova.apresentarResultados;
      prova.apresentarResultadosPorItem = provaStoreAtualizada.prova.apresentarResultadosPorItem;
      prova.provaComProficiencia = provaStoreAtualizada.prova.provaComProficiencia;

      prova.exibirAudio = provaStoreAtualizada.prova.exibirAudio;
      prova.exibirVideo = provaStoreAtualizada.prova.exibirVideo;

      provaStoreAtualizada.prova = prova;
      provaStoreAtualizada.downloadStatus = prova.downloadStatus;
    }

    await provaDao.inserirOuAtualizar(provaStoreAtualizada.prova);

    if (provaStoreAtualizada.downloadStatus == EnumDownloadStatus.ATUALIZAR) {
      info('Prova ${provaStoreAtualizada.id} alterada. Iniciando atualização');
      provaStoreAtualizada.iniciarDownload();
    }
  }

  @disposeMethod
  onDispose() {
    cancelarTimers();
    limpar();
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
