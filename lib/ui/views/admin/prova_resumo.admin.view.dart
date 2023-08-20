import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/admin_prova_resumo.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/string.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class AdminProvaResumoView extends BaseStatefulWidget {
  final int idProva;
  final String? nomeCaderno;

  AdminProvaResumoView({
    Key? key,
    @PathParam('idProva') required this.idProva,
    @PathParam('nomeCaderno') this.nomeCaderno,
  }) : super(key: key);

  @override
  State<AdminProvaResumoView> createState() => _AdminProvaResumoViewState();
}

class _AdminProvaResumoViewState extends BaseStateWidget<AdminProvaResumoView, AdminProvaResumoViewStore> {
  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.carregarResumo(widget.idProva, caderno: widget.nomeCaderno);
  }

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      leading: _buildBotaoVoltarLeading(context),
    );
  }

  Widget? _buildBotaoVoltarLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        if (widget.nomeCaderno != null) {
          context.router.navigate(
            AdminProvaCadernoViewRoute(
              idProva: widget.idProva,
            ),
          );
        } else {
          context.router.navigate(HomeAdminViewRoute());
        }
      },
    );
  }

  @override
  Widget builder(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: getPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Texto(
                    'Resumo da prova',
                    textAlign: TextAlign.start,
                    color: TemaUtil.preto,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  //
                  SizedBox(height: 20),
                  Observer(builder: (_) {
                    if (store.carregando) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Column(
                      children: [
                        _buildCabecalho(),
                        _divider(),
                        ..._buildListaRespostas(),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCabecalho() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Texto(
            "Questão",
            fontSize: 14,
            color: TemaUtil.appBar,
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: Texto(
              "Visualizar item",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  List<Widget> _buildListaRespostas() {
    var resumo = store.resumo;
    List<Widget> questoes = [];

    for (var item in resumo) {
      questoes.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: _buildResumo(item),
        ),
      );
      questoes.add(_divider());
    }

    return questoes;
  }

  Widget _buildResumo(AdminProvaResumoResponseDTO questaoResumo) {
    String ordemQuestaoTratada =
        questaoResumo.ordem < 10 ? '0${questaoResumo.ordem + 1}' : '${questaoResumo.ordem + 1}';

    String titulo = ordemQuestaoTratada +
        " - " +
        tratarTexto(questaoResumo.titulo ?? "") +
        tratarTexto(questaoResumo.descricao ?? "");

    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Texto(
            titulo,
            maxLines: 1,
            fontSize: 14,
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: _buildVisualizar(questaoResumo.ordem, questaoResumo.id),
          ),
        )
      ],
    );
  }

  _buildVisualizar(questaoOrdem, questaoId) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        context.router.push(
          AdminProvaQuestaoViewRoute(
            key: ValueKey("${widget.idProva}-${widget.nomeCaderno}-$questaoOrdem"),
            idProva: widget.idProva,
            nomeCaderno: widget.nomeCaderno,
            ordem: questaoOrdem,
          ),
        );
      },
      child: SvgPicture.asset(
        AssetsUtil.iconeRevisarQuestao,
      ),
    );
  }
}
