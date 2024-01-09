import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/daos/contexto_prova.dao.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'contexto_prova_view.store.g.dart';

@LazySingleton()
class ContextoProvaViewStore = _ContextoProvaViewStoreBase with _$ContextoProvaViewStore;

abstract class _ContextoProvaViewStoreBase with Store {
  final AppDatabase db;

  @observable
  bool loading = false;

  @observable
  List<ContextoProva>? contextoProva;

  _ContextoProvaViewStoreBase(
    this.db,
  );

  @action
  carregarContextoProva(int provaId) async {
    loading = true;

    ContextoProvaDao contextoDao = db.contextoProvaDao;

    contextoProva = await contextoDao.obterPorProvaId(provaId);

    loading = false;
  }
}
