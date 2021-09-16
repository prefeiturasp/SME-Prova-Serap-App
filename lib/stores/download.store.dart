import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';

part 'download.store.g.dart';

class DownloadStore = _DownloadStoreBase with _$DownloadStore;

abstract class _DownloadStoreBase with Store {
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

  @computed
  double get progressoDownload => posicaoAtual / totalItems > 1 ? 1 : posicaoAtual / totalItems;

  @observable
  bool possuiConexao = true;

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
  }

  @action
  Future<void> verificaConexaoComInternet() async {
    var resultadoDaVerificacao = await (Connectivity().checkConnectivity());

    if (resultadoDaVerificacao == ConnectivityResult.wifi ||
        resultadoDaVerificacao == ConnectivityResult.mobile ||
        resultadoDaVerificacao == ConnectivityResult.ethernet) {
      possuiConexao = true;
    } else {
      possuiConexao = false;
    }
  }
}
