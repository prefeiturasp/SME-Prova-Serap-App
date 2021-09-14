import 'package:appserap/models/prova.model.dart';
import 'package:appserap/repositories/prova.repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  ObservableFuture<List<ProvaModel>> fetchReposFuture = emptyResponse;

  @computed
  bool get hasResults => fetchReposFuture != emptyResponse && fetchReposFuture.status == FutureStatus.fulfilled;

  static ObservableFuture<List<ProvaModel>> emptyResponse = ObservableFuture.value([]);

  List<ProvaModel> provas = [];

  @action
  Future<List<ProvaModel>> fetchProvas() async {
    provas = [];
    final future = GetIt.I.get<ProvaRepository>().obterProvas();
    fetchReposFuture = ObservableFuture(future);

    return provas = await future;
  }
}
