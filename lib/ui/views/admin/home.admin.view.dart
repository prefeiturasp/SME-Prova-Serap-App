import 'dart:convert';

import 'package:appserap/dtos/admin_prova.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/stores/home.admin.store.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.widget.dart';
import 'package:appserap/ui/widgets/adaptative/center.widger.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialog_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class HomeAdminView extends BaseStatefulWidget {
  HomeAdminView({Key? key}) : super(key: key);

  @override
  State<HomeAdminView> createState() => _HomeAdminViewState();
}

class _HomeAdminViewState extends BaseStateWidget<HomeAdminView, HomeAdminStore> {
  FocusNode _codigoProvaFocus = FocusNode();

  @override
  bool get exibirSair => true;

  @override
  bool get exibirVoltar => false;

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.carregarProvas();
  }

  @override
  void dispose() {
    store.onDispose();
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Observer(builder: (_) {
                    return TextFormField(
                      initialValue: store.codigoSerap,
                      decoration: InputDecoration(
                        labelText: "Código da prova",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      onChanged: (value) {
                        store.codigoSerap = value;
                      },
                      onFieldSubmitted: (value) async {
                        await store.filtrar();
                      },
                    );
                  }),
                ),
              ),
              Expanded(
                flex: 10,
                child: Observer(builder: (_) {
                  return TextFormField(
                    initialValue: store.desricao,
                    decoration: InputDecoration(
                      labelText: "Descrição da prova",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onChanged: (value) {
                      store.desricao = value;
                    },
                    onFieldSubmitted: (value) async {
                      if (value.length > 3 || value.isEmpty) {
                        await store.filtrar();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DropdownSearch<ModalidadeEnum>(
                  showClearButton: true,
                  items: ModalidadeEnum.values.filter((element) => element.codigo != 0).toList(),
                  itemAsString: (item) => item.nome,
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Selecione a modalidade",
                    labelText: "Modalidade",
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  ),
                  onChanged: (ModalidadeEnum? newValue) async {
                    store.modalidade = newValue;
                    await store.filtrar();
                  },
                ),
              ),
            ),

            //Ano

            Expanded(
              flex: 4,
              child: DropdownSearch<String>(
                showClearButton: true,
                items: List<String>.generate(9, (i) => (i + 1).toString()),
                itemAsString: (item) => item + "º",
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Selecione o ano de aplicação da prova",
                  labelText: "Ano",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                ),
                onChanged: (String? newValue) async {
                  store.ano = newValue;
                  await store.filtrar();
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                await store.carregarProvas(refresh: true);
              },
              child: Observer(builder: (_) {
                return _buildItens();
              }),
            ),
          ),
        ),
      ],
    );
  }

  _buildItens() {
    return ListView.builder(
      itemCount: store.provas.length + 1,
      itemBuilder: (_, index) {
        if (store.provas.isEmpty && !store.carregando) {
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 400,
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

        if (store.carregando) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (index == store.provas.length) {
          if (store.totalPaginas > store.pagina) {
            store.carregarProvas();
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox.shrink();
          }
        }
        return _buildProva(store.provas[index]);
      },
    );
  }

  _buildProva(AdminProvaResponseDTO prova) {
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
          child: Row(children: [
            ..._buildProvaIcon(prova),
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
                              prova.totalItens.toString(),
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
                  AdaptativeCenter(
                    center: kIsMobile,
                    child: _buildBotao(prova),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildProvaIcon(AdminProvaResponseDTO prova) {
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

  Widget _formataDataAplicacao(AdminProvaResponseDTO prova) {
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
                    formatEddMMyyyy(prova.dataFim),
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
                    formatEddMMyyyy(prova.dataFim),
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

  _buildBotao(AdminProvaResponseDTO prova) {
    String texto = 'VISUALIZAR PROVA';

    var tamanhoFonte = 14.0;
    if (kIsMobile) {
      tamanhoFonte = 14.0;
      if (temaStore.incrementador >= 22) {
        tamanhoFonte = 12.0;
      }
    }

    return BotaoDefaultWidget(
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
        if (prova.senha != null) {
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
                      onChanged: (value) => store.codigoIniciarProva = value,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Digite o código para liberar a prova',
                        labelStyle: TextStyle(
                          color: _codigoProvaFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                        ),
                      ),
                      onSubmitted: (value) => _confirmarSenha(prova),
                    ),
                  ),
                ),
                botoes: [
                  BotaoDefaultWidget(
                    onPressed: () {
                      _confirmarSenha(prova);
                    },
                    textoBotao: "ENVIAR CODIGO",
                  ),
                ],
              );
            },
          );
        } else {
          _navegarProva(prova);
        }
      },
    );
  }

  _navegarProva(AdminProvaResponseDTO prova) {
    if (prova.possuiContexto) {
      context.push("/admin/prova/${prova.id}/contexto", extra: {'possuiBIB': prova.possuiBIB});
    } else {
      if (prova.possuiBIB) {
        context.push("/admin/prova/${prova.id}/caderno");
      } else {
        context.push("/admin/prova/${prova.id}/resumo");
      }
    }
  }

  void _confirmarSenha(AdminProvaResponseDTO prova) {
    String senhaCriptografada = md5.convert(utf8.encode(store.codigoIniciarProva)).toString();

    if (prova.senha == senhaCriptografada) {
      Navigator.pop(context);

      _navegarProva(prova);
    } else {
      mostrarDialogSenhaErrada(context);
    }
  }
}
