import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/home.store.dart';

import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/home/home.view.util.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_tab.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock/clock.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class ProvasAnterioresTabView extends BaseStatefulWidget {
  ProvasAnterioresTabView({Key? key}) : super(key: key);

  @override
  _ProvasAnterioresTabViewState createState() => _ProvasAnterioresTabViewState();
}

class _ProvasAnterioresTabViewState extends BaseTabWidget<ProvasAnterioresTabView, HomeStore>
    with Loggable, HomeViewUtil {
  final temaStore = GetIt.I<TemaStore>();

  @override
  Widget builder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Observer(
        builder: (_) {
          if (store.carregando) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await store.carregarProvas();
            },
            child: _buildItens(store.provas),
          );
        },
      ),
    );
  }

  _buildItens(ObservableMap<int, ProvaStore> provasStore) {
    var listProvas = provasStore.filter((p) => p.value.prova.isFinalizada()).toMap();

    var mapEntries = listProvas.entries.toList()
      ..sort((a, b) => b.value.prova.dataFimProvaAluno!.compareTo(a.value.prova.dataFimProvaAluno!));

    listProvas
      ..clear()
      ..addEntries(mapEntries);

    if (listProvas.isEmpty) {
      return Center(
        key: Key('sem-itens-finalizados'),
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
      itemCount: listProvas.length,
      itemBuilder: (_, index) {
        var key = listProvas.keys.toList()[index];
        var provaStore = listProvas[key];
        return _buildProva(provaStore!.prova);
      },
    );
  }

  _buildProva(Prova prova) {
    return Padding(
      padding: getPadding(EdgeInsets.symmetric(horizontal: 8)),
      child: Card(
        key: Key('card-prova-finalizada'),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: TemaUtil.cinza, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ..._buildProvaIcon(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titulo
                    Texto(
                      prova.descricao,
                      textOverflow: TextOverflow.visible,
                      fontSize: 18,
                      bold: true,
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
                        //
                        Observer(builder: (_) {
                          return AdaptativeWidget(
                            mode: temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC &&
                                    temaStore.incrementador > 22 &&
                                    kIsMobile
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
                                prova.itensQuantidade.toString(),
                                fontSize: 14,
                                color: TemaUtil.preto,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          );
                        }),
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
                              fontSize: 14,
                            ),
                            Observer(builder: (_) {
                              return _formataDataAplicacao(prova);
                            }),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Botao
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: Texto(
                        "Finalizada em ${formatDateddMMyyyaskkmm(prova.dataFimProvaAluno)}",
                        color: TemaUtil.laranja01,
                        bold: true,
                        maxLines: 2,
                        fontSize: 12,
                      ),
                    ),
                    _buildBotaoVisualizarRespostas(prova),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBotaoVisualizarRespostas(Prova prova) {
    var temDataFinal = prova.dataFim != null;

    if (!prova.apresentarResultados || !temDataFinal || isDepoisData(Clock().now(), prova.dataFim!)) {
      return Container();
    }

    var tamanhoFonte = temaStore.tTexto16;
    if (kIsMobile) {
      tamanhoFonte = temaStore.tTexto14;
    }

    double largura = 256;

    if (temaStore.incrementador >= 22) {
      largura = 300;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BotaoDefaultWidget(
        key: Key('botao-visualizar-resposta'),
        largura: kIsTablet ? largura : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Colors.white, size: 18),
            Texto(
              " Resultados",
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: tamanhoFonte,
            ),
          ],
        ),
        onPressed: () async {
          context.push("/prova/resposta/${prova.id}/${prova.caderno}/resumo");
        },
      ),
    );
  }

  List<Widget> _buildProvaIcon() {
    if (kIsTablet) {
      return [
        Container(
          width: 128,
          padding: EdgeInsets.only(
            right: 16,
          ),
          child: SvgPicture.asset(
            AssetsUtil.iconeProva,
          ),
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
}
