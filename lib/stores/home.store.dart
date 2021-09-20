import 'dart:convert';

import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  ObservableList<ProvaStore> provas = ObservableList<ProvaStore>();

  @observable
  bool carregando = false;

  @action
  carregarProvas() async {
    carregando = true;
    var response = await GetIt.I.get<ApiService>().prova.getProvas();

    List<ProvaStore> provasStore = [];

    if (response.isSuccessful) {
      provasStore = response.body!
          .map((e) => ProvaStore(
                id: e.id,
                prova: Prova(
                  id: e.id,
                  itensQuantidade: e.itensQuantidade,
                  dataInicio: e.dataInicio,
                  dataFim: e.dataFim,
                  descricao: e.descricao,
                  questoes: [],
                ),
                status: EnumDownloadStatus.NAO_INICIADO,
              ))
          .toList()
          .asObservable();
    }

    if (provasStore.isNotEmpty) {
      for (var prova in provasStore) {
        prova.setupReactions();
        await carregaProva(prova);
      }
    }

    provas = ObservableList.of(provasStore);
    carregando = false;
  }

  Future<void> carregaProva(ProvaStore provaStore) async {
    SharedPreferences _pref = GetIt.I.get();

    String? provaJson = _pref.getString('prova_${provaStore.id}');

    if (provaJson != null) {
      var prova = Prova.fromJson(jsonDecode(provaJson));

      provaStore.prova = prova;
      provaStore.status = prova.status;
      provaStore.progressoDownload = prova.progressoDownload;

      if (provaStore.status != EnumDownloadStatus.CONCLUIDO) {
        provaStore.iniciarDownload();
      }
    } else {
      await _pref.setString('prova_${provaStore.prova.id}', jsonEncode(provaStore.prova.toJson()));
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
