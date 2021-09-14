import 'dart:developer';

import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/download.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/prova/prova.view.dart';
import 'package:appserap/widgets/inputs/botao_padrao.widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProvaCardWidget extends StatefulWidget {
  final ProvaModel prova;

  ProvaCardWidget({required this.prova});

  @override
  _ProvaCardWidgetState createState() => _ProvaCardWidgetState();
}

class _ProvaCardWidgetState extends State<ProvaCardWidget> {
  final _provaStore = GetIt.I.get<ProvaStore>();
  final _downloadStore = GetIt.I.get<DownloadStore>();
  final _provaController = GetIt.I.get<ProvaController>();

  @override
  void initState() {
    initializeDateFormatting();
    Intl.defaultLocale = 'pt_BR';
    super.initState();
  }

  // String iconeProva = "assets/images/prova.svg";
  // String iconeProvaDownload = "assets/images/prova_download.svg";
  // String iconeProvaDownloadErro = "assets/images/prova_erro_download.svg";

  Widget acaoProva() {
    if (_provaStore.prova == null ||
        _provaStore.prova!.status == ProvaStatusEnum.Baixar) {
      return BotaoPadraoWidget(
        textoBotao: "BAIXAR PROVA",
        largura: 300,
        onPressed: () async {
          _provaController.verificaConexaoComInternet();
          _provaStore.carregarProva(this.widget.prova);
          var provaDetalhes =
              await _provaController.obterDetalhesProva(this.widget.prova.id);
          if (provaDetalhes != null) {
            _provaStore.carregarProvaDetalhes(provaDetalhes);
            //_provaController.downloadProva(this.widget.prova, provaDetalhes);
            _provaStore.alterarStatus(ProvaStatusEnum.DowloadEmProgresso);
            setState(() {});
          }
        },
      );
    }

    if (_provaStore.prova!.status == ProvaStatusEnum.DowloadEmProgresso) {
      if (!_provaStore.baixando) {
        _provaController
            .downloadProva(this.widget.prova, _provaStore.detalhes)
            .then((value) => null);
      }

      _provaStore.setMensagemDownload(
        "Download em progresso ${(_downloadStore.progressoDownload * 100).toStringAsFixed(2)}%",
      );

      return Container(
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              return LinearPercentIndicator(
                //animation: true,
                //animationDuration: 1000,
                lineHeight: 7.0,
                percent: _downloadStore.progressoDownload,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: TemaUtil.verde01,
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Observer(builder: (_) {
                return Text(_provaStore.mensagemDownload);
              }),
            ),
          ],
        ),
      );
    }

    if (_provaStore.prova!.status == ProvaStatusEnum.IniciarProva) {
      return BotaoPadraoWidget(
        textoBotao: "INICAR A PROVA",
        largura: 350,
        onPressed: () async {
          await _provaStore.carregarProvaCompletaStorage(this.widget.prova.id);
          debugger();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProvaView(),
            ),
          );
        },
      );
    }

    if (_provaStore.prova!.status == ProvaStatusEnum.DownloadNaoIniciado) {
      return Container(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              return LinearPercentIndicator(
                //animation: true,
                //animationDuration: 1000,
                lineHeight: 7.0,
                percent: _downloadStore.progressoDownload,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: TemaUtil.verde01,
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Observer(builder: (_) {
                return Text(
                  _provaStore.mensagemDownload,
                  style: TextStyle(
                    color: TemaUtil.vermelhoErro,
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }

    if (_provaStore.prova!.status == ProvaStatusEnum.DownloadPausado) {
      return Container(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              return LinearPercentIndicator(
                //animation: true,
                //animationDuration: 1000,
                lineHeight: 7.0,
                percent: _downloadStore.progressoDownload,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: TemaUtil.verde01,
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Observer(builder: (_) {
                return Text(
                  _provaStore.mensagemDownload,
                  style: TextStyle(
                    color: TemaUtil.vermelhoErro,
                  ),
                );
              }),
            ),
            TextButton(
              onPressed: () async {
                _downloadStore.limparDownloads();
                _provaController.verificaConexaoComInternet();
                _provaStore.carregarProva(this.widget.prova);
                var provaDetalhes = await _provaController
                    .obterDetalhesProva(this.widget.prova.id);
                if (provaDetalhes != null) {
                  _provaStore.carregarProvaDetalhes(provaDetalhes);
                  //_provaController.downloadProva(this.widget.prova, provaDetalhes);
                  _provaStore.alterarStatus(ProvaStatusEnum.DowloadEmProgresso);
                  setState(() {});
                }
              },
              child: Text("Tentar novamente"),
            ),
          ],
        ),
      );
    }

    return SizedBox();
  }

  Widget formataDataAplicacao() {
    if (this.widget.prova.dataFim == null ||
        this.widget.prova.dataInicio == this.widget.prova.dataFim) {
      return AutoSizeText(
        "${DateFormat("E - dd/MM/yyyy").format(this.widget.prova.dataInicio!)}",
        maxLines: 2,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    if (this.widget.prova.dataInicio != this.widget.prova.dataFim) {
      return Row(
        children: [
          AutoSizeText(
            "${DateFormat("E - dd/MM/yyyy").format(this.widget.prova.dataInicio!)}",
            maxLines: 2,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          AutoSizeText(
            " à ",
            maxLines: 2,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          AutoSizeText(
            "${DateFormat("E - dd/MM/yyyy").format(this.widget.prova.dataFim!)}",
            maxLines: 2,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: TemaUtil.branco,
        border: Border.all(color: TemaUtil.cinza),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Observer(builder: (_) {
                  return Container(
                    width: 100,
                    child: SvgPicture.asset(_provaStore.iconeProva),
                  );
                }),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 350,
                        child: AutoSizeText(
                          this.widget.prova.descricao,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: TemaUtil.laranja02.withOpacity(0.1),
                            ),
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.format_list_numbered,
                              color: TemaUtil.laranja02,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Quantidade de itens:",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " ${this.widget.prova.itensQuantidade}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: TemaUtil.verde02.withOpacity(0.1),
                            ),
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.insert_invitation,
                              color: TemaUtil.verde02,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Data de aplicação:",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 350,
                                child: formataDataAplicacao(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Observer(
                        builder: (_) {
                          return acaoProva();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
