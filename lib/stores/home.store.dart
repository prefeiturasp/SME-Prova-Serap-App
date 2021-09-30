import 'dart:convert';
import 'dart:io';

import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova_resposta.store.dart';
import 'package:chopper/src/response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store, Loggable {
  @observable
  ObservableList<ProvaStore> provas = ObservableList<ProvaStore>();

  @observable
  bool carregando = false;

  @action
  carregarProvas() async {
    carregando = true;
    List<ProvaStore> provasStore = [];
    ConnectivityResult resultado = await (Connectivity().checkConnectivity());
    if (resultado != ConnectivityResult.none) {
      try {
        Response<List<ProvaResponseDTO>> response = await GetIt.I.get<ApiService>().prova.getProvas();

        if (response.isSuccessful) {
          var provasResponse = response.body!;

          for (var provaResponse in provasResponse) {
            var provaStore = ProvaStore(
              id: provaResponse.id,
              prova: Prova(
                id: provaResponse.id,
                itensQuantidade: provaResponse.itensQuantidade,
                dataInicio: provaResponse.dataInicio,
                dataFim: provaResponse.dataFim,
                descricao: provaResponse.descricao,
                status: provaResponse.status,
                questoes: [],
              ),
              respostas: ProvaRespostaStore(idProva: provaResponse.id),
            );
            provaStore.downloadStatus = EnumDownloadStatus.NAO_INICIADO;

            provasStore.add(provaStore);
          }
        }
      } on SocketException {
        // Carrega provas do cache
        List<int> ids = listProvasCache();

        for (var id in ids) {
          var provaBanco = Prova.carregaProvaCache(id)!;
          provasStore.add(ProvaStore(
            id: id,
            prova: provaBanco,
            respostas: ProvaRespostaStore(idProva: id),
          ));
        }
      } catch (e, stacktrace) {
        severe(e);
        severe(stacktrace);
      }
    } else {
      // Carrega provas do cache
      List<int> ids = listProvasCache();

      for (var id in ids) {
        var provaBanco = Prova.carregaProvaCache(id)!;
        provasStore.add(ProvaStore(
          id: id,
          prova: provaBanco,
          respostas: ProvaRespostaStore(idProva: id),
        ));
      }
    }

    if (provasStore.isNotEmpty) {
      for (var provaStore in provasStore) {
        provaStore.setupReactions();
        await carregaProva(provaStore.id, provaStore);
      }
    }
    provas = ObservableList.of(provasStore);

    carregando = false;
  }

  List<int> listProvasCache() {
    SharedPreferences prefs = GetIt.I.get();

    var ids = prefs.getKeys().toList().where((element) => element.startsWith('prova_'));

    if (ids.isNotEmpty) {
      return ids.map((e) => e.replaceAll('prova_', '')).map((e) => int.parse(e)).toList();
    }
    return [];
  }

  Future<void> carregaProva(int idProva, ProvaStore provaStore) async {
    Prova? prova = Prova.carregaProvaCache(idProva);

    if (prova != null) {
      provaStore.prova = prova;
      provaStore.downloadStatus = prova.downloadStatus;
      provaStore.progressoDownload = prova.downloadProgresso;
      provaStore.status = prova.status;
    } else {
      await Prova.salvaProvaCache(provaStore.prova);
    }

    if (provaStore.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
      provaStore.iniciarDownload();
    }
  }

  @action
  dispose() {
    limpar();
  }

  @action
  limpar() {
    provas = <ProvaStore>[].asObservable();
  }
}
