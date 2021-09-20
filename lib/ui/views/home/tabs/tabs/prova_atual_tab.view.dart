import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProvaAtualTabView extends StatefulWidget {
  @override
  State<ProvaAtualTabView> createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends State<ProvaAtualTabView> {
  final store = GetIt.I.get<HomeStore>();

  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      child: Observer(
        builder: (_) {
          var provas = store.provas;

          return store.carregando
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : provas.isNotEmpty
                  ? ListView.builder(
                      itemCount: provas.length,
                      itemBuilder: (_, index) {
                        var prova = provas[index];
                        return Observer(builder: (_) => _buildProva(prova));
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/sem_prova.svg'),
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }

  Widget _formataDataAplicacao(Prova prova) {
    if (prova.dataFim == null || prova.dataInicio == prova.dataFim) {
      return AutoSizeText(
        formatEddMMyyyy(prova.dataInicio),
        maxLines: 2,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    if (prova.dataInicio != prova.dataFim) {
      return Row(
        children: [
          AutoSizeText(
            formatEddMMyyyy(prova.dataInicio),
            maxLines: 2,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          AutoSizeText(
            " à ",
            maxLines: 2,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          AutoSizeText(
            formatEddMMyyyy(prova.dataFim!),
            maxLines: 2,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return SizedBox();
  }

  _buildBotao(ProvaStore provaStore) {
    if (_principalStore.status == ConnectivityResult.none && provaStore.status != EnumDownloadStatus.CONCLUIDO) {
      return _buildSemConexao();
    }

    // Baixar prova
    if (provaStore.status == EnumDownloadStatus.NAO_INICIADO && _principalStore.status != ConnectivityResult.none) {
      return _buildBaixarProva(provaStore);
    }

    // Baixando prova
    if (provaStore.status == EnumDownloadStatus.BAIXANDO && _principalStore.status != ConnectivityResult.none) {
      return _buildDownloadProgresso(provaStore);
    }

    // Prova baixada -- iniciar
    if (provaStore.status == EnumDownloadStatus.CONCLUIDO) {
      return _buildIniciarProva(provaStore);
    }

    return SizedBox.shrink();
  }

  _buildProva(ProvaStore provaStore) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: TemaUtil.branco,
        border: Border.all(color: TemaUtil.cinza),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (_) {
              return SvgPicture.asset(provaStore.icone);
            }),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titulo
                  AutoSizeText(
                    provaStore.prova.descricao,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  // Quantidade de itens
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: TemaUtil.laranja02.withOpacity(0.1),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.format_list_numbered,
                          color: TemaUtil.laranja02,
                          size: 24,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Quantidade de itens: ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      TextoDefaultWidget(
                        provaStore.prova.itensQuantidade.toString(),
                        fontSize: 16,
                        bold: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Data aplicacao
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: TemaUtil.verde02.withOpacity(0.1),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.insert_invitation,
                          color: TemaUtil.verde02,
                          size: 24,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextoDefaultWidget(
                            "Data de aplicação:",
                            fontSize: 16,
                          ),
                          SizedBox(
                            width: 350,
                            child: _formataDataAplicacao(provaStore.prova),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Botao
                  Observer(builder: (_) {
                    return _buildBotao(provaStore);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemConexao() {
    return Container(
      width: 350,
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 4.0,
              percent: 0.01,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: TextoDefaultWidget(
              "Download pausado - Sem conexão com a internet",
              color: TemaUtil.vermelhoErro,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaixarProva(ProvaStore provaStore) {
    return BotaoDefaultWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.download, color: Colors.white, size: 18),
          TextoDefaultWidget(" BAIXAR PROVA", color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ],
      ),
      largura: 256,
      onPressed: () async {
        await provaStore.iniciarDownload();
      },
    );
  }

  Widget _buildIniciarProva(ProvaStore provaStore) {
    return BotaoDefaultWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoDefaultWidget("INICAR A PROVA ", color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      largura: 256,
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProvaView(
              provaStore: provaStore,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadProgresso(ProvaStore prova) {
    var tempoRestante =
        prova.tempoPrevisto > 0 ? " - Aproximadamente ${prova.tempoPrevisto.round()} segundos restantes" : "";

    return Container(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            //animation: true,
            //animationDuration: 1000,
            lineHeight: 4.0,
            percent: prova.progressoDownload,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: TemaUtil.verde01,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Text("Download em progresso ${(prova.progressoDownload * 100).toStringAsFixed(2)}% $tempoRestante"),
          ),
        ],
      ),
    );
  }
}
