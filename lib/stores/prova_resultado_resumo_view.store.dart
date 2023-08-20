import 'dart:convert';

import 'package:appserap/dtos/prova_resultado_resumo.response.dto.dart';
import 'package:appserap/dtos/prova_resultado_resumo_questao.response.dto.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/chopper.dart';
// import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'prova_resultado_resumo_view.store.g.dart';

// @Injectable()
class ProvaResultadoResumoViewStore = _ProvaResultadoResumoViewStoreBase with _$ProvaResultadoResumoViewStore;

abstract class _ProvaResultadoResumoViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  int totalQuestoes = 0;

  @observable
  ProvaResultadoResumoResponseDto? response;

  @observable
  Prova? prova;

  @action
  carregarResumo({required int provaId, required String caderno}) async {
    carregando = true;
    await retry(
          () async {
        prova = await db.provaDao.obterPorProvaIdECaderno(provaId, caderno);

        Response<ProvaResultadoResumoResponseDto> res = await sl<ProvaResultadoService>().getResumoPorProvaId(
          provaId: provaId,
        );

        if (res.isSuccessful) {
          response = res.body!;

          cacheResumoProva(provaId, caderno, response!.resumos);
          totalQuestoes = response!.resumos.length;
        }
      },
      onRetry: (e) {
        fine('[Prova $provaId] - Tentativa de carregamento Resumo Prova - ${e.toString()}');
      },
    );

    carregando = false;
  }

  Future<void> cacheResumoProva(int idProva, String? caderno, List<ProvaResultadoResumoQuestaoResponseDto> resumos) async {
    var pref = sl<SharedPreferences>();

    List<Future> futures = [];


    for(ProvaResultadoResumoQuestaoResponseDto resumo in resumos){
      String key = 't-$idProva-$caderno-${resumo.ordemQuestao}';
      String value = jsonEncode(resumo.toJson());

      futures.add(pref.setString(key, value));
    }

    await Future.wait(futures);
  }
}
