import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_stateless.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialog_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';

class ProvaAtualTabView extends BaseStatefulWidget {
  @override
  State<ProvaAtualTabView> createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends BaseStatelessWidget<ProvaAtualTabView, HomeStore> {
  final _principalStore = GetIt.I.get<PrincipalStore>();

  FocusNode _codigoProvaFocus = FocusNode();

  @override
  void onAfterBuild(BuildContext context) {
    store.carregarProvas();
  }

  @override
  Widget builder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      child: Observer(
        builder: (_) {
          ObservableMap<int, ProvaStore> provas = store.provas;

          if (store.carregando) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provas.isEmpty) {
            return Padding(
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
          }

          return RefreshIndicator(
            onRefresh: () async {
              await store.carregarProvas();
            },
            child: ListView.builder(
              itemCount: provas.length,
              itemBuilder: (_, index) {
                var keys = provas.keys.toList();
                var prova = provas[keys[index]]!;
                return _buildProva(prova);
              },
            ),
          );
        },
      ),
    );
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
                      Texto(
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
                          Texto(
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
    // Download não iniciado e sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.NAO_INICIADO && !_principalStore.temConexao) {
      return _buildSemConexao(provaStore);
    }

    // Download prova pausado sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.PAUSADO && !_principalStore.temConexao) {
      return _buildPausado(provaStore);
    }

    // Baixar prova
    if (provaStore.downloadStatus == EnumDownloadStatus.NAO_INICIADO && _principalStore.temConexao) {
      return _buildBaixarProva(provaStore);
    }

    // Baixando prova
    if (provaStore.downloadStatus == EnumDownloadStatus.BAIXANDO && _principalStore.temConexao) {
      return _buildDownloadProgresso(provaStore);
    }

    // Prova baixada -- iniciar
    if (provaStore.downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      if (provaStore.status == EnumProvaStatus.PENDENTE) {
        // Prova finalizada - aguardando sincronização
        return _buildProvaPendente(provaStore);
      } else {
        // Prova não finalizada
        return _buildIniciarProva(provaStore);
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildSemConexao(ProvaStore provaStore) {
    return SizedBox(
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
              percent: provaStore.progressoDownload,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Download não iniciado",
                  color: TemaUtil.vermelhoErro,
                  fontSize: 12,
                  bold: true,
                ),
                Texto(
                  " - Sem conexão com a internet",
                  color: TemaUtil.vermelhoErro,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausado(ProvaStore provaStore) {
    return SizedBox(
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
              percent: provaStore.progressoDownload,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Pausado em ${(provaStore.progressoDownload * 100).toStringAsFixed(1)}%",
                  color: TemaUtil.vermelhoErro,
                  fontSize: 12,
                  bold: true,
                ),
                Texto(
                  " - Sem conexão com a internet",
                  color: TemaUtil.vermelhoErro,
                  fontSize: 12,
                ),
              ],
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
          Texto(" BAIXAR PROVA", color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ],
      ),
      largura: 256,
      onPressed: () async {
        await provaStore.iniciarDownload();
      },
    );
  }

  Widget _buildProvaPendente(ProvaStore provaStore) {
    return SizedBox(
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
              lineHeight: 7.0,
              percent: 1,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.laranja02,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Aguardando envio",
                  color: TemaUtil.laranja01,
                  fontSize: 12,
                  bold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIniciarProva(ProvaStore provaStore) {
    String texto = '';

    switch (provaStore.prova.status) {
      case EnumProvaStatus.INICIADA:
        texto = "CONTINUAR PROVA";
        break;
      default:
        texto = "INICIAR PROVA";
    }

    return BotaoDefaultWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Texto('$texto ', color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      largura: 256,
      onPressed: () async {

        if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA && provaStore.prova.senha != null) {
          //
          showDialog(
            context: context,
            barrierColor: Colors.black87,
            builder: (context) {
              return DialogDefaultWidget(
                cabecalho: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    "Insira a senha informada para iniciar a prova",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                corpo: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: TextField(
                      focusNode: _codigoProvaFocus,
                      onChanged: (value) => provaStore.codigoIniciarProva = value,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Digite o código para liberar a prova',
                        labelStyle: TextStyle(
                          color: _codigoProvaFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                        ),
                      ),
                    ),
                  ),
                ),
                botoes: [
                  BotaoDefaultWidget(
                    onPressed: () {
                      String senhaCriptografada = md5.convert(utf8.encode(provaStore.codigoIniciarProva)).toString();

                      if (provaStore.prova.senha == senhaCriptografada) {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProvaView(
                              provaStore: provaStore,
                            ),
                          ),
                        );
                      } else {
                        mostrarDialogSenhaErrada(context);
                      }
                    },
                    textoBotao: "ENVIAR CODIGO",
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProvaView(
                provaStore: provaStore,
              ),
            ),
          );
        }

        if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA && provaStore.prova.senha == null) {
          provaStore.iniciarProva();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProvaView(
                provaStore: provaStore,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDownloadProgresso(ProvaStore prova) {
    var tempoRestante =
        prova.tempoPrevisto > 0 ? " - Aproximadamente ${prova.tempoPrevisto.round()} segundos restantes" : "";

    return SizedBox(
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
  //
}
