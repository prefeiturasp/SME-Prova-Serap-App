import 'package:appserap/dtos/prova_alternativa.dto.dart';
import 'package:appserap/dtos/prova_arquivo.dto.dart';
import 'package:appserap/dtos/prova_questao.dto.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/services/prova.service.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'prova.model.g.dart';

class ProvaModel = _ProvaModelBase with _$ProvaModel;

abstract class _ProvaModelBase with Store {
  final _provaService = GetIt.I.get<ProvaService>();

  @observable
  int id = 0;

  @observable
  DateTime? dataFim;

  @observable
  DateTime? dataInicio;

  @observable
  int itensQuantidade = 0;

  @observable
  String descricao = "";

  @observable
  ProvaStatusEnum status = ProvaStatusEnum.Baixar;

  @observable
  String icone = "assets/images/prova.svg";

  @observable
  int posicaoAtual = 1;

  @observable
  List<int>? questoesId;

  @observable
  List<int>? arquivosId;

  @observable
  List<int>? alternativasId;

  @observable
  int? tamanhoTotalArquivos;

  @observable
  List<ProvaArquivoDTO> arquivos = [];

  @observable
  List<ProvaQuestaoDTO> questoes = [];

  @observable
  List<ProvaAlternativaDTO> alternativas = [];

  @observable
  DateTime inicioDownload = DateTime.now();

  @computed
  num get totalItems => questoesId!.length + arquivosId!.length + alternativasId!.length;

  @computed
  int get tempoGasto => inicioDownload.difference(DateTime.now()).inSeconds * -1;

  @computed
  double get tempoPrevisto => ((posicaoAtual / ((inicioDownload.difference(DateTime.now()).inSeconds) + 1)) * -1) > 0
      ? (((totalItems - posicaoAtual) / (posicaoAtual / ((inicioDownload.difference(DateTime.now()).inSeconds) + 1))) *
          -1)
      : 0;

  @computed
  double get progressoDownload => posicaoAtual / totalItems > 1 ? 1 : posicaoAtual / totalItems;

  @action
  setId(int valor) => id = valor;

  @action
  setStatus(ProvaStatusEnum valor) => status = valor;

  @action
  setIcone(String valor) => icone = valor;

  @action
  setDescricao(String valor) => descricao = valor;

  @action
  setItensQuantidade(int valor) => itensQuantidade = valor;

  @action
  setDataInicio(DateTime valor) => dataInicio = valor;

  @action
  setDataFim(DateTime valor) => dataFim = valor;

  @action
  setQuestoesId(List<int> valor) => questoesId = valor;

  @action
  setArquivosId(List<int> valor) => arquivosId = valor;

  @action
  setAlternativasId(List<int> valor) => alternativasId = valor;

  @action
  setTamanhoTotalArquivos(int valor) => tamanhoTotalArquivos = valor;

  @action
  setPosicaoAtual(int valor) => posicaoAtual = valor;

  @action
  incrementPosicaoAtual() => posicaoAtual += 1;

  @action
  Future<void> baixar() async {
    setIcone("assets/images/prova_download.svg");
    setStatus(ProvaStatusEnum.DowloadEmProgresso);
    setPosicaoAtual(0);

    for (int arquivoId in arquivosId!) {
      var arquivo = await _provaService.obterArquivo(arquivoId);

      if (arquivo != null) {
        if (arquivos.where((q) => q.id == arquivo.id).isEmpty) {
          var arquivoMetadata = await _provaService.obterImagemPorUrl(arquivo.caminho);
          arquivo.base64 = arquivoMetadata.base64;
          arquivos.add(arquivo);
          print("Arquivo: ${arquivo.id}");
          incrementPosicaoAtual();
        }
      }
    }

    for (int questaoId in questoesId!) {
      var questao = await _provaService.obterQuestao(questaoId);

      if (questao != null) {
        if (questoes.where((q) => q.id == questao.id).isEmpty) {
          questoes.add(questao);
          //_downloadStore.posicaoAtual += 1;
          print("Questao: ${questao.id}");
          incrementPosicaoAtual();
        }
      }
    }

    for (int alternativaId in alternativasId!) {
      var alternativa = await _provaService.obterAlternativa(alternativaId);

      if (alternativa != null) {
        if (alternativas.where((q) => q.id == alternativa.id).isEmpty) {
          alternativas.add(alternativa);
          //_downloadStore.posicaoAtual += 1;
          print("alternativa: ${alternativa.id}");
          incrementPosicaoAtual();
        }
      }
    }

    for (ProvaQuestaoDTO questao in this.questoes) {
      var alternativas = this.alternativas.where((alt) => alt.questaoId == questao.id).toList();

      questao.alternativas = alternativas;
    }

    setIcone("assets/images/prova.svg");
    setStatus(ProvaStatusEnum.IniciarProva);
  }
}
