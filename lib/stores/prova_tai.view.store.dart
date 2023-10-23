import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
part 'prova_tai.view.store.g.dart';

@LazySingleton()
class ProvaTaiViewStore = _ProvaTaiViewStoreBase with _$ProvaTaiViewStore;

abstract class _ProvaTaiViewStoreBase with Store, Loggable {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;

  final ProvaTaiService _provaTaiService;

  @observable
  bool carregando = false;

  @observable
  bool taiDisponivel = false;

  @observable
  ProvaStore? provaStore;

  _ProvaTaiViewStoreBase(
    this.db,
    this.dbRespostas,
    this._provaTaiService,
  );

  @action
  Future<bool?> configurarProva(int provaId) async {
    carregando = true;

    try {
      var prova = await db.provaDao.obterPorProvaId(provaId);
      provaStore = ProvaStore(prova: prova);

      var responseConexao = await _provaTaiService.existeConexaoR();

      if (responseConexao.isSuccessful) {
        taiDisponivel = responseConexao.body!;

        if (taiDisponivel) {
          if (provaStore!.prova.status == EnumProvaStatus.NAO_INICIADA) {
            await provaStore!.setStatusProva(EnumProvaStatus.INICIADA);
            await provaStore!.setHoraInicioProva(DateTime.now());

            await _provaTaiService.iniciarProva(
              provaId: provaId,
              status: EnumProvaStatus.INICIADA.index,
              tipoDispositivo: kDeviceType.index,
              dataInicio: getTicks(provaStore!.prova.dataInicioProvaAluno!),
            );
          }
        }
      } else {
        taiDisponivel = false;
      }
    } on Exception catch (exception, stack) {
      taiDisponivel = false;
      await recordError(exception, stack, reason: 'Erro ao configurar prova TAI');
    }

    await WakelockPlus.enable();

    carregando = false;

    return taiDisponivel;
  }
}
