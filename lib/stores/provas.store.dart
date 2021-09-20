import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/prova.service.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'provas.store.g.dart';

class ProvasStore = _ProvasStoreBase with _$ProvasStore;

abstract class _ProvasStoreBase with Store {
  final _provaService = GetIt.I.get<ProvaService>();

  @observable
  ObservableList<ProvaModel> provas = ObservableList<ProvaModel>();

  @observable
  bool carregando = false;

  @action
  limpar() {
    provas = ObservableList<ProvaModel>();
  }

  @action
  carregarProvas() async {
    carregando = true;
    var retorno = await _provaService.obterProvas();
    for (var dto in retorno) {
      var prova = ProvaModel();
      prova.setItensQuantidade(dto.itensQuantidade);
      prova.setDataFim(dto.dataFim!);
      prova.setDataInicio(dto.dataInicio!);
      prova.setDescricao(dto.descricao);
      prova.setId(dto.id);

      var detalhes = await _provaService.obterDetalhesProva(dto.id);
      if (detalhes != null) {
        prova.setAlternativasId(detalhes.alternativasId!);
        prova.setArquivosId(detalhes.arquivosId!);
        prova.setTamanhoTotalArquivos(detalhes.tamanhoTotalArquivos!);
        prova.setQuestoesId(detalhes.questoesId!);
      }

      provas.add(prova);
    }

    carregando = false;
  }

  @action
  baixarProva(int id) async {
    var prova = provas.firstWhere((element) => element.id == id);
    //var index = provas.indexOf(prova);

    prova.baixar();
  }
}
