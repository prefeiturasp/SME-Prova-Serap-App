import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/widgets/cards/prova_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:appserap/models/prova.model.dart';
import 'package:appserap/controllers/prova.controller.dart';
import 'package:get_it/get_it.dart';
import 'package:appserap/stores/prova.store.dart';

class ProvaAtualPage extends StatefulWidget {
  const ProvaAtualPage({Key? key}) : super(key: key);

  @override
  _ProvaAtualPageState createState() => _ProvaAtualPageState();
}

class _ProvaAtualPageState extends State<ProvaAtualPage> {
  final _provaController = GetIt.I.get<ProvaController>();
  List<ProvaModel> provas = <ProvaModel>[];
  final _provaStore = GetIt.I.get<ProvaStore>();

  @override
  void initState() {
    super.initState();

    _provaStore.limparProvas();
    obterProvas();
  }

  obterProvas() async {
    //var prefs = await SharedPreferences.getInstance();
    var retorno = await _provaController.obterProvas();
    // for (var prova in retorno) {
    //   prefs.setString("prova_${prova.id}", jsonEncode(prova));
    // }
    setState(() {
      provas = retorno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: provas.length,
                itemBuilder: (_, index) {
                  var prova = provas[index];
                  return ProvaCardWidget(
                    prova: prova,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
