import 'package:appserap/stores/admin_prova_caderno.store.dart';
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

class AdminProvaCadernoView extends BaseStatefulWidget {
  final int idProva;
  AdminProvaCadernoView({
    Key? key,
    @pathParam required this.idProva,
  }) : super(key: key);

  @override
  State<AdminProvaCadernoView> createState() => _AdminProvaCadernoViewState();
}

class _AdminProvaCadernoViewState extends BaseStateWidget<AdminProvaCadernoView, AdminProvaCadernoViewStore> {
  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.carregarCadernos(widget.idProva);
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      leading: _buildBotaoVoltarLeading(context),
    );
  }

  Widget? _buildBotaoVoltarLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        context.router.navigateNamed("/admin");
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Texto(
              'Listagem de Cadernos',
              textAlign: TextAlign.start,
              color: TemaUtil.preto,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            Texto(
              'Selecione um caderno para visualizar as questões:',
              textAlign: TextAlign.start,
              color: TemaUtil.preto,
              fontSize: 14,
            ),
            Divider(height: 40),
            Observer(builder: (_) {
              if (store.carregando) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              store.cadernos.sort((a, b) {
                if (isNumeric(a) && isNumeric(b)) {
                  return int.parse(a) - int.parse(b);
                }
                return a.compareTo(b);
              });

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildCabecalho(),
                    _divider(),
                    ..._buildListaCadernos(),
                  ],
                ),
              );
            })
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
            "Caderno",
            fontSize: 14,
            color: TemaUtil.appBar,
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: Texto(
              "Abrir Caderno",
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

  List<Widget> _buildListaCadernos() {
    var cadernos = store.cadernos;
    List<Widget> questoes = [];

    for (var caderno in cadernos) {
      questoes.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: _buildCaderno(caderno),
        ),
      );
      questoes.add(_divider());
    }

    return questoes;
  }

  Widget _buildCaderno(String nomeCaderno) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Texto(
            "Caderno $nomeCaderno",
            maxLines: 1,
            fontSize: 14,
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: _buildVisualizar(nomeCaderno),
          ),
        )
      ],
    );
  }

  _buildVisualizar(String nomeCaderno) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        context.router.pushNamed("/admin/prova/${widget.idProva}/caderno/$nomeCaderno/resumo");
      },
      child: SvgPicture.asset(
        AssetsUtil.iconeRevisarQuestao,
      ),
    );
  }
}
