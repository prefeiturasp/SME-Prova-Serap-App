import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/data_hora_servidor.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/views/home/home.view.util.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.widget.dart';
import 'package:appserap/ui/widgets/adaptative/center.widger.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_tab.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialog_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/extensions/date.extension.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:supercharged/supercharged.dart';

class ProvaAtualTabView extends BaseStatefulWidget {
  @override
  State<ProvaAtualTabView> createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends BaseTabWidget<ProvaAtualTabView, HomeStore> with Loggable, HomeViewUtil {
  final _principalStore = GetIt.I.get<PrincipalStore>();
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  final temaStore = GetIt.I<TemaStore>();

  FocusNode _codigoProvaFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    store.carregarProvas();
  }

  @override
  Widget builder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Observer(
        builder: (_) {
          ObservableMap<int, ProvaStore> provasStore = store.provas;

          if (store.carregando) {
            return Center(
              key: Key('carregando'),
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await store.carregarProvas();
            },
            child: _buildItens(provasStore),
          );
        },
      ),
    );
  }

  _buildItens(ObservableMap<int, ProvaStore> provasStore) {
    var listProvas = provasStore.filter((p) => verificaProvaVigente(p.value) && !p.value.prova.isFinalizada()).toMap();

    if (listProvas.isEmpty) {
      return Center(
        key: Key("sem-itens"),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: SvgPicture.asset(
                  'assets/images/sem_prova.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Texto(
                  "Você não tem novas\nprovas para fazer.",
                  fontSize: 18,
                  center: true,
                  fontWeight: FontWeight.w600,
                  color: TemaUtil.pretoSemFoco3,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      key: Key("lista-provas"),
      itemCount: listProvas.length,
      itemBuilder: (_, index) {
        var key = listProvas.keys.toList()[index];
        var provaStore = listProvas[key];
        return _buildProva(provaStore!);
      },
    );
  }

  _buildProva(ProvaStore provaStore) {
    return Padding(
      padding: getPadding(EdgeInsets.symmetric(horizontal: 8)),
      child: Card(
        key: Key("card-prova"),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: TemaUtil.cinza, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            ..._buildProvaIcon(provaStore),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titulo
                  Texto(
                    provaStore.prova.descricao,
                    textOverflow: TextOverflow.visible,
                    fontSize: 18,
                    bold: true,
                  ),
                  SizedBox(height: 10),
                  // Quantidade de itens
                  _buildQuantidadeItens(provaStore),
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
                            fontSize: 14,
                          ),
                          Observer(builder: (_) {
                            return _formataDataAplicacao(provaStore.prova);
                          }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Botao
                  AdaptativeCenter(
                    center: kIsMobile,
                    child: Observer(builder: (_) {
                      return _buildBotao(provaStore);
                    }),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildProvaIcon(ProvaStore provaStore) {
    if (kIsTablet || sl<PrincipalStore>().temConexao) {
      return [
        Container(
          width: 128,
          padding: EdgeInsets.only(
            right: 16,
          ),
          child: Observer(builder: (_) {
            return SvgPicture.asset(
              provaStore.icone,
            );
          }),
        ),
      ];
    } else {
      return [];
    }
  }

  Widget _formataDataAplicacao(Prova prova) {
    var tamanhoFonte = temaStore.tTexto14;

    if (prova.dataFim == null || prova.dataInicio == prova.dataFim) {
      return AutoSizeText(
        formatEddMMyyyy(prova.dataInicio),
        maxLines: 4,
        style: TemaUtil.temaTextoPadraoNegrito.copyWith(
          fontSize: tamanhoFonte,
          fontFamily: temaStore.fonteDoTexto.nomeFonte,
        ),
      );
    }

    if (prova.dataInicio != prova.dataFim) {
      int tamanhoFonteParaQuebrarTexto = 18;

      if (kIsMobile) {
        tamanhoFonte = temaStore.tTexto16;
        tamanhoFonteParaQuebrarTexto = 14;

        if (temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC) {
          tamanhoFonte = temaStore.tTexto14;
          tamanhoFonteParaQuebrarTexto = 12;
        }
      }

      return Container(
        child: tamanhoFonte >= tamanhoFonteParaQuebrarTexto
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    formatEddMMyyyy(prova.dataInicio),
                    maxLines: 2,
                    style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                      fontSize: tamanhoFonte,
                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: AutoSizeText(
                      " à ",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TemaUtil.temaTextoPadrao.copyWith(
                        fontSize: tamanhoFonte,
                        fontFamily: temaStore.fonteDoTexto.nomeFonte,
                      ),
                    ),
                  ),
                  AutoSizeText(
                    formatEddMMyyyy(prova.dataFim!),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                      fontSize: tamanhoFonte,
                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  AutoSizeText(
                    formatEddMMyyyy(prova.dataInicio),
                    maxLines: 1,
                    style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                      fontSize: tamanhoFonte,
                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    ),
                  ),
                  AutoSizeText(
                    " à ",
                    maxLines: 1,
                    style: TemaUtil.temaTextoPadrao.copyWith(
                      fontSize: tamanhoFonte,
                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    ),
                  ),
                  AutoSizeText(
                    formatEddMMyyyy(prova.dataFim!),
                    maxLines: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                      fontSize: tamanhoFonte,
                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    ),
                  ),
                ],
              ),
      );
    }

    return SizedBox();
  }

  _buildBotao(ProvaStore provaStore) {
    // ProvaTai
    if (provaStore.prova.formatoTai) {
      return _buildBotaoProvaTai(provaStore);
    }

    // Download não iniciado e sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.NAO_INICIADO && !_principalStore.temConexao) {
      return _buildSemConexao(provaStore);
    }

    // Download prova pausado sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.PAUSADO && !_principalStore.temConexao) {
      return _buildPausado(provaStore);
    }

    // Download prova error - Download pausado
    if (provaStore.downloadStatus == EnumDownloadStatus.ERRO) {
      return _buildErro(provaStore);
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
      bool provaDisponivel = verificaProvaTurno(provaStore, _usuarioStore) &&
              provaStore.possuiTempoExecucao() &&
              verificaProvaDisponivel(provaStore) ||
          !provaStore.possuiTempoExecucao();

      if (!provaDisponivel) {
        return _buildProvaTurnoIndisponivel(provaStore);
      } else {
        if (provaStore.status == EnumProvaStatus.PENDENTE) {
          // Prova finalizada - aguardando sincronização
          return _buildProvaPendente(provaStore);
        } else {
          //
          //Prova não finalizada
          return _buildIniciarProva(provaStore);
        }
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildSemConexao(ProvaStore provaStore) {
    return SizedBox(
      key: Key('card-sem-conexao'),
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            lineHeight: 4.0,
            percent: provaStore.progressoDownload,
            barRadius: const Radius.circular(16),
            progressColor: TemaUtil.vermelhoErro,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Text.rich(
              TextSpan(
                text: "Download não iniciado",
                style: TextStyle(
                  color: TemaUtil.vermelhoErro,
                  fontSize: temaStore.size(12),
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: " - Sem conexão com a internet",
                    style: TextStyle(fontWeight: FontWeight.normal, color: TemaUtil.vermelhoErro),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausado(ProvaStore provaStore) {
    return SizedBox(
      key: Key('card-download-pausado'),
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
              barRadius: const Radius.circular(16),
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Erro ao baixar prova - ",
                  color: TemaUtil.vermelhoErro,
                  bold: true,
                  texStyle: TemaUtil.temaTextoErroNegrito.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Texto(
                  "pausado em ${(provaStore.progressoDownload * 100).toStringAsFixed(1)}%",
                  color: TemaUtil.vermelhoErro,
                  texStyle: TemaUtil.temaTextoErro.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErro(ProvaStore provaStore) {
    return SizedBox(
      key: Key('card-download-erro'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            lineHeight: 4.0,
            percent: provaStore.progressoDownload,
            barRadius: const Radius.circular(16),
            progressColor: TemaUtil.vermelhoErro,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Texto(
                  "Erro ao baixar prova - ",
                  color: TemaUtil.vermelhoErro,
                  bold: true,
                  texStyle: TemaUtil.temaTextoErroNegrito.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Texto(
                  "pausado em ${(provaStore.progressoDownload * 100).toStringAsFixed(1)}%",
                  color: TemaUtil.vermelhoErro,
                  texStyle: TemaUtil.temaTextoErro.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _buildBotaoTentarNovamente(provaStore),
        ],
      ),
    );
  }

  Widget _buildBotaoTentarNovamente(ProvaStore provaStore) {
    var tamanhoFonte = temaStore.tTexto16;
    if (kIsMobile) {
      tamanhoFonte = temaStore.tTexto14;
    }

    double largura = 256;

    if (temaStore.incrementador >= 22) {
      largura = 300;
    }

    return BotaoDefaultWidget(
      key: Key('botao-baixar-novamente-prova'),
      largura: kIsTablet ? largura : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.restart_alt, color: Colors.white, size: 18),
          Texto(
            " REINICIAR DOWNLOAD",
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: tamanhoFonte,
          ),
        ],
      ),
      onPressed: () async {
        await provaStore.iniciarDownload();
      },
    );
  }

  Widget _buildBaixarProva(ProvaStore provaStore) {
    var tamanhoFonte = temaStore.tTexto16;
    if (kIsMobile) {
      tamanhoFonte = temaStore.tTexto14;
    }

    double largura = 256;

    if (temaStore.incrementador >= 22) {
      largura = 300;
    }

    return BotaoDefaultWidget(
      key: Key('botao-baixar-prova'),
      largura: kIsTablet ? largura : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.download, color: Colors.white, size: 18),
          Texto(
            " BAIXAR PROVA",
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: tamanhoFonte,
          ),
        ],
      ),
      onPressed: () async {
        await provaStore.iniciarDownload();
      },
    );
  }

  Widget _buildProvaPendente(ProvaStore provaStore) {
    return SizedBox(
      key: Key('card-prova-pendente'),
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            lineHeight: 7.0,
            percent: 1,
            barRadius: const Radius.circular(16),
            progressColor: TemaUtil.laranja02,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Aguardando envio",
                  color: TemaUtil.laranja01,
                  bold: true,
                  fontSize: 12,
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
    String key = '';

    switch (provaStore.prova.status) {
      case EnumProvaStatus.INICIADA:
        texto = "CONTINUAR PROVA";
        key = "botao-prova-continuar";
        break;
      default:
        texto = "INICIAR PROVA";
        key = "botao-prova-iniciar";
    }

    var tamanhoFonte = 14.0;
    if (kIsMobile) {
      tamanhoFonte = 14.0;
      if (temaStore.incrementador >= 22) {
        tamanhoFonte = 12.0;
      }
    }

    return BotaoDefaultWidget(
      key: Key(key),
      largura: kIsTablet ? 256 : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Texto(
            '$texto ',
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: tamanhoFonte,
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      onPressed: () async {
        await verificarHoraServidor();

        if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA) {
          if (provaStore.prova.senha != null) {
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
                    child: Texto(
                      "Insira a senha informada para iniciar a prova",
                      center: true,
                      fontSize: tamanhoFonte,
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

                          _navegarParaProvaPrimeiraVez(provaStore);
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
            _navegarParaProvaPrimeiraVez(provaStore);
          }
        } else if (provaStore.prova.status == EnumProvaStatus.INICIADA) {
          context.router.navigate(ProvaViewRoute(idProva: provaStore.id));
        }
      },
    );
  }

  verificarHoraServidor() async {
    if (!_principalStore.temConexao) {
      return;
    }

    try {
      var response = await sl<ConfiguracaoService>().getDataHoraServidor();

      if (response.isSuccessful) {
        DataHoraServidorDTO body = response.body!;

        DateTime dataHoraServidor = body.dataHora;
        int tolerancia = body.tolerancia;

        if ((dataHoraServidor.difference(DateTime.now()).inMinutes).abs() >= tolerancia) {
          await horaDispositivoIncorreta(context, dataHoraServidor);
        }
      }
    } catch (e, stack) {
      recordError(e, stack, reason: 'Erro ao obter hora do servidor');
    }
  }

  _navegarParaProvaPrimeiraVez(ProvaStore provaStore) async {
    bool iniciarProva = true;

    if (provaStore.possuiTempoExecucao()) {
      var fimTurno = sl<UsuarioStore>().fimTurno;

      var tempoTotalDisponivel = provaStore.prova.tempoExecucao;
      var tempoDisponivel = DateTime.now().copyWith(hour: fimTurno, minute: 0, second: 0).difference(DateTime.now());

      if (tempoDisponivel.inSeconds < tempoTotalDisponivel) {
        iniciarProva = await mostrarDialogNaoPossuiTempoTotalDisponivel(context, tempoDisponivel) ?? false;
      }
    }

    if (iniciarProva) {
      if (await sl<AppDatabase>().contextoProvaDao.possuiContexto(provaStore.id)) {
        context.router.navigate(
          ContextoProvaViewRoute(
            idProva: provaStore.id,
          ),
        );
      } else {
        context.router.navigate(ProvaViewRoute(idProva: provaStore.id));
      }
    }
  }

  Widget _buildDownloadProgresso(ProvaStore prova) {
    String tempoPrevisto = "0";

    if (!prova.tempoPrevisto.isNaN) {
      tempoPrevisto = formatDuration(Duration(seconds: prova.tempoPrevisto.toInt()));
    }

    var tempoRestante = prova.tempoPrevisto > 0 ? " - Aproximadamente $tempoPrevisto restantes" : "";

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            lineHeight: 4.0,
            percent: prova.progressoDownload,
            barRadius: const Radius.circular(16),
            progressColor: TemaUtil.verde01,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Observer(builder: (_) {
              return Text.rich(
                TextSpan(
                  text: "Download em ${(prova.progressoDownload * 100).toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: TemaUtil.preto2,
                    fontSize: temaStore.size(12),
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: tempoRestante,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProvaTurnoIndisponivel(ProvaStore provaStore) {
    return SizedBox(
      key: Key("prova-indiponivel-turno"),
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Texto(
              "A execução da prova estará disponível no seu turno",
              maxLines: 2,
              color: TemaUtil.laranja01,
              bold: true,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  _buildBotaoProvaTai(ProvaStore provaStore) {
    String texto = '';
    String key = '';

    switch (provaStore.prova.status) {
      case EnumProvaStatus.INICIADA:
        texto = "CONTINUAR PROVA";
        key = "botao-prova-continuar-tai";
        break;
      default:
        texto = "INICIAR PROVA";
        key = "botao-prova-iniciar-tai";
    }

    var tamanhoFonte = 14.0;
    if (kIsMobile) {
      tamanhoFonte = 14.0;
      if (temaStore.incrementador >= 22) {
        tamanhoFonte = 12.0;
      }
    }

    return BotaoDefaultWidget(
      key: Key(key),
      largura: kIsTablet ? 256 : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Texto(
            '$texto ',
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: tamanhoFonte,
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      onPressed: () async {
        await verificarHoraServidor();

        context.router.push(ProvaTaiViewRoute(
          key: ValueKey(provaStore.id),
          provaId: provaStore.id,
        ));
      },
    );
  }

  Widget _buildQuantidadeItens(ProvaStore provaStore) {
    if (provaStore.prova.formatoTai) {
      return SizedBox.shrink();
    }

    return Row(
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
        //
        Observer(builder: (_) {
          return AdaptativeWidget(
            mode: temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC && temaStore.incrementador > 22 && kIsMobile
                ? AdaptativeWidgetMode.COLUMN
                : AdaptativeWidgetMode.ROW,
            children: [
              Texto(
                "Quantidade de itens: ",
                fontSize: 14,
                color: TemaUtil.preto,
                fontWeight: FontWeight.normal,
              ),
              Texto(
                provaStore.prova.itensQuantidade.toString(),
                fontSize: 14,
                color: TemaUtil.preto,
                fontWeight: FontWeight.bold,
              ),
            ],
          );
        }),
      ],
    );
  }
}
