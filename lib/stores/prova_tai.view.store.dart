import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:mobx/mobx.dart';
part 'prova_tai.view.store.g.dart';

class ProvaTaiViewStore = _ProvaTaiViewStoreBase with _$ProvaTaiViewStore;

abstract class _ProvaTaiViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  bool? taiDisponivel;

  @observable
  ProvaStore? provaStore;

  @action
  Future<bool?> configurarProva(int provaId) async {
    carregando = true;

    if (provaStore == null) {
      var prova = await db.provaDao.obterPorProvaId(provaId);

      provaStore = ProvaStore(prova: prova);
    }

    if (provaStore!.prova.status == EnumProvaStatus.NAO_INICIADA) {
      await provaStore!.setStatusProva(EnumProvaStatus.INICIADA);
      await provaStore!.setHoraInicioProva(DateTime.now());

      var response = await ServiceLocator.get<ApiService>().provaTai.iniciarProva(
            provaId: provaId,
            status: EnumProvaStatus.INICIADA.index,
            tipoDispositivo: kDeviceType.index,
            dataInicio: getTicks(provaStore!.prova.dataInicioProvaAluno!),
          );

      if (response.isSuccessful) {
        taiDisponivel = response.body!;
      } else {
        taiDisponivel = false;
      }
    } else {
      taiDisponivel = true;
    }

    carregando = false;

    return taiDisponivel;
  }
}
