import 'package:mobx/mobx.dart';

part 'questao.store.g.dart';

class QuestaoStore = _QuestaoStoreBase with _$QuestaoStore;

abstract class _QuestaoStoreBase with Store {

  @observable
  bool botaoOcupado = false;

  @observable
  bool isLoading = true;
}