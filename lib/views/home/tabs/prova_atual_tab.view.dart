import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/provas.store.dart';
import 'package:appserap/widgets/cards/prova_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class ProvaAtualTabView extends StatefulWidget {
  const ProvaAtualTabView({Key? key}) : super(key: key);

  @override
  _ProvaAtualTabViewState createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends State<ProvaAtualTabView> with AutomaticKeepAliveClientMixin<ProvaAtualTabView> {
  @override
  bool get wantKeepAlive => false;

  final _provaController = GetIt.I.get<ProvaController>();
  List<ProvaModel> provas = <ProvaModel>[];
  final _provaStore = GetIt.I.get<ProvaStore>();
  final _provasStore = GetIt.I.get<ProvasStore>();

  @override
  void initState() {
    super.initState();

    _provaStore.limparProvas();
    _provaStore.setupReactions();
    obterProvas();
  }

  @override
  void dispose() {
    _provaStore.dispose();
    super.dispose();
  }

  obterProvas() async {
    await _provaController.obterProvas().then(
          (value) => _provasStore.provas = value,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      child: Column(
        children: [
          _provasStore.provas.length > 0
              ? Expanded(
                  child: Container(
                    child: Observer(builder: (_) {
                      return ListView.builder(
                        itemCount: _provasStore.provas.length,
                        itemBuilder: (_, index) {
                          var prova = _provasStore.provas[index];
                          return ProvaCardWidget(
                            prova: prova,
                          );
                        },
                      );
                    }),
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
}
