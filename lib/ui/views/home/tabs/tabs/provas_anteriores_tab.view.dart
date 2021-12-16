import 'package:appserap/dtos/prova_anterior.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/home_provas_anteriores.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.widget.dart';
import 'package:appserap/ui/widgets/adaptative/center.widger.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_stateless.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class ProvasAnterioresTabView extends BaseStatefulWidget {
  ProvasAnterioresTabView({Key? key}) : super(key: key);

  @override
  _ProvasAnterioresTabViewState createState() => _ProvasAnterioresTabViewState();
}

class _ProvasAnterioresTabViewState extends BaseStatelessWidget<ProvasAnterioresTabView, HomeProvasAnterioresStore>
    with Loggable {
  final temaStore = GetIt.I<TemaStore>();

  @override
  void initState() {
    super.initState();
    store.carregarProvasAnteriores();
  }

  @override
  Widget builder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Observer(
        builder: (context) {
          return ListView.builder(
            itemCount: store.provasAnteriores.length,
            itemBuilder: (context, index) {
              var prova = store.provasAnteriores[index];

              return _buidCardProva(prova);
            },
          );
        },
      ),
    );
  }

  _buidCardProva(ProvaAnteriorResponseDTO prova) {
    return Padding(
      padding: getPadding(EdgeInsets.symmetric(horizontal: 8)),
      child: Card(
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
                        texStyle: TemaUtil.temaTextoAguardandoEnvio.copyWith(
                          fontSize: temaStore.tTexto12,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Widget _formataDataAplicacao(ProvaAnteriorResponseDTO prova) {
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
