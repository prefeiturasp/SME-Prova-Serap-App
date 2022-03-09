import 'package:appserap/stores/admin_prova_caderno.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/string.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class AdminProvaCadernoView extends BaseStatefulWidget {
  final int idProva;
  AdminProvaCadernoView({Key? key, required this.idProva}) : super(key: key);

  @override
  State<AdminProvaCadernoView> createState() => _AdminProvaCadernoViewState();
}

class _AdminProvaCadernoViewState extends BaseStateWidget<AdminProvaCadernoView, AdminProvaCadernoViewStore> {
  @override
  bool get exibirVoltar => true;

  @override
  void initState() {
    super.initState();
    store.carregarCadernos(widget.idProva);
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...store.cadernos.map((e) => _buildCadernos(e)).toList(),
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  _buildCadernos(String nomeCaderno) {
    return TextButton(
      onPressed: () {
        context.push("/admin/prova/${widget.idProva}/caderno/$nomeCaderno/resumo");
      },
      child: Texto(
        "Caderno $nomeCaderno",
        fontSize: 16,
      ),
    );
  }
}
