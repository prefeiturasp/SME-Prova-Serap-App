import 'dart:convert';

import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/src/response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'admin_prova_resumo.store.g.dart';

@LazySingleton()
class AdminProvaResumoViewStore = _AdminProvaResumoViewStoreBase with _$AdminProvaResumoViewStore;

abstract class _AdminProvaResumoViewStoreBase with Store, Loggable {
  final AdminService _adminService;
  final SharedPreferences _sharedPreferences;

  @observable
  bool carregando = false;

  @observable
  ObservableList<AdminProvaResumoResponseDTO> resumo = ObservableList<AdminProvaResumoResponseDTO>();

  _AdminProvaResumoViewStoreBase(
    this._adminService,
    this._sharedPreferences,
  );

  @action
  carregarResumo(int idProva, {String? caderno}) async {
    carregando = true;
    await retry(
      () async {
        Response<List<AdminProvaResumoResponseDTO>> res;
        if (caderno != null) {
          res = await _adminService.getResumoByCaderno(idProva: idProva, caderno: caderno);
        } else {
          res = await _adminService.getResumo(idProva: idProva);
        }

        if (res.isSuccessful) {
          resumo = res.body!.asObservable();

          cacheResumoProva(idProva, caderno, resumo);
        }
      },
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento Resumo Prova - ${e.toString()}');
      },
    );

    carregando = false;
  }

  Future<void> cacheResumoProva(
      int idProva, String? caderno, ObservableList<AdminProvaResumoResponseDTO> resumos) async {
    List<Future> futures = [];

    for (AdminProvaResumoResponseDTO resumo in resumos) {
      String key = 'a-$idProva-$caderno-${resumo.ordem}';
      String value = jsonEncode(resumo.toJson());

      futures.add(_sharedPreferences.setString(key, value));
    }

    await Future.wait(futures);
  }
}
