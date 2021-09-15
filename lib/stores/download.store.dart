import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';

part 'download.store.g.dart';

class DownloadStore = _DownloadStoreBase with _$DownloadStore;

abstract class _DownloadStoreBase with Store {
  @computed
  double get progressoDownload => posicaoAtual / totalItems > 1 ? 1 : posicaoAtual / totalItems;

  @observable
  int posicaoAtual = 0;

  @observable
  num totalItems = 0;

  @observable
  num tamanhoTotalArquivos = 0;

  @observable
  num tamanhoAtualArquivos = 0;

  @observable
  DateTime inicio = DateTime.now();

  @computed
  int get tempoGasto => inicio.difference(DateTime.now()).inSeconds;

  @computed
  double get tempoPrevisto => (((totalItems - posicaoAtual) / (posicaoAtual / tempoGasto)) * -1);

  @action
  atualizarProgresso(int atual) {
    posicaoAtual += atual;
  }

  @action
  atualizarProgressoArquivos(int atual) {
    tamanhoAtualArquivos += atual;
  }

  @action
  void atualizaHoraInicial() {
    this.inicio = DateTime.now();
  }

  @action
  Future<void> limparDownloads() async {
    this.posicaoAtual = 0;
    this.totalItems = 0;
    this.tamanhoAtualArquivos = 0;
    this.tamanhoTotalArquivos = 0;
    // await prefs.clear();
  }

  //! ANALISAR PROPOSTA DE IMPLEMENTAÇÃO
  @observable
  double tamanhoDoArquivo = 0;
  @action
  void setTamanhoDoArquivo(double tamanho) => this.tamanhoDoArquivo = tamanho;

  @observable
  double velocidadeTransferencia = 0;
  @action
  void setVelocidadeTransferencia(double velocidade) => this.velocidadeTransferencia = velocidade;

  @observable
  double porcentagemDownload = 0;
  @action
  void setPorcentagemDownload(double porcentagem) => this.porcentagemDownload = porcentagem;

  final divisor = 8;

  @observable
  Duration tempoRestante = Duration(seconds: 0);
  @action
  void setTempoRestante(Duration tempo) => this.tempoRestante = tempo;

  @observable
  bool possuiConexao = false;

  // @action
  // void setPossuiConexao(bool possuiConexao) => this.possuiConexao = possuiConexao;

  // @action
  // Future<void> verificaConexaoComInternet() async {
  //   var resultadoDaVerificacao = await (Connectivity().checkConnectivity());

  //   if (resultadoDaVerificacao == ConnectivityResult.wifi ||
  //       resultadoDaVerificacao == ConnectivityResult.mobile ||
  //       resultadoDaVerificacao == ConnectivityResult.ethernet) {
  //     this.setPossuiConexao(true);
  //   } else {
  //     this.setPossuiConexao(false);
  //   }
  // }
}
