import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/main.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/date_util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/prova/prova.view.dart';
import 'package:appserap/widgets/inputs/botao_padrao.widget.dart';
import 'package:appserap/widgets/texto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProvaAtualTabView extends StatefulWidget {
  const ProvaAtualTabView({Key? key}) : super(key: key);

  @override
  _ProvaAtualTabViewState createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends State<ProvaAtualTabView> with AutomaticKeepAliveClientMixin<ProvaAtualTabView> {
  @override
  bool get wantKeepAlive => false;

  final _provaController = GetIt.I.get<ProvaController>();
  final _provaStore = GetIt.I.get<ProvaStore>();
  final _mainStore = GetIt.I.get<MainStore>();

  List<ProvaModel> provas = <ProvaModel>[];

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';

    _provaStore.limparProvas();
    obterProvas();
  }

  obterProvas() async {
    var retorno = await _provaController.obterProvas();

    setState(() {
      provas = retorno;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      child: Column(
        children: [
          provas.length > 0
              ? Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: provas.length,
                      itemBuilder: (_, index) {
                        var prova = provas[index];
                        return _buildProva(prova);
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/sem_prova.svg'),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _buildProva(ProvaModel prova) {
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
              return Container(
                child: SvgPicture.asset(_provaStore.iconeProva),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titulo
                  AutoSizeText(
                    prova.descricao,
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
                        prova.itensQuantidade.toString(),
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
                            child: _formataDataAplicacao(prova),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Botao
                  Observer(builder: (_) {
                    return _buildBotao(prova);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formataDataAplicacao(ProvaModel prova) {
    if (prova.dataFim == null || prova.dataInicio == prova.dataFim) {
      return AutoSizeText(
        formatEddMMyyyy(prova.dataInicio!),
        maxLines: 2,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    if (prova.dataInicio != prova.dataFim) {
      return Row(
        children: [
          AutoSizeText(
            formatEddMMyyyy(prova.dataInicio!),
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

  _buildBotao(ProvaModel prova) {
    if (_mainStore.status == ConnectivityResult.none && prova.status == ProvaStatusEnum.Baixar) {
      return _buildSemConexao(prova);
    }

    // Baixar prova
    if (prova.status == ProvaStatusEnum.Baixar && _mainStore.status != ConnectivityResult.none) {
      return _buildBaixarProva(prova);
    }

    // Prova baixada -- iniciar
    if (prova.status == ProvaStatusEnum.IniciarProva) {
      return _buildIniciarProva(prova);
    }

    return SizedBox.shrink();
  }

  Widget _buildSemConexao(ProvaModel prova) {
    return Container(
      width: 350,
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
            child: Texto(
              "Download não iniciado - Sem conexão com a internet",
              color: TemaUtil.vermelhoErro,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaixarProva(ProvaModel prova) {
    return BotaoPadraoWidget(
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
        var provaDetalhes = await _provaController.obterDetalhesProva(prova.id);
        if (provaDetalhes != null) {
          _provaStore.carregarProvaDetalhes(provaDetalhes);
          //_provaController.downloadProva(this.widget.prova, provaDetalhes);
          _provaStore.alterarStatus(ProvaStatusEnum.DowloadEmProgresso);
        }
      },
    );
  }

  Widget _buildIniciarProva(ProvaModel prova) {
    return BotaoPadraoWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Texto("INICAR A PROVA ", color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      largura: 256,
      onPressed: () async {
        await _provaStore.carregarProvaCompletaStorage(prova.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProvaView()));
      },
    );
  }
}
