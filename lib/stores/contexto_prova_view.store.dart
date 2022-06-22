import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/daos/contexto_prova.dao.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:mobx/mobx.dart';
part 'contexto_prova_view.store.g.dart';

class ContextoProvaViewStore = _ContextoProvaViewStoreBase with _$ContextoProvaViewStore;

abstract class _ContextoProvaViewStoreBase with Store {
  @observable
  bool loading = false;

  @observable
  late List<ContextoProva> contextoProva;

  @action
  carregarContextoProva(int provaId) async {
    loading = true;

    ContextoProvaDao contextoDao = ServiceLocator.get<AppDatabase>().contextoProvaDao;

    contextoProva = await contextoDao.obterPorProvaId(provaId);

    loading = false;
  }
}
