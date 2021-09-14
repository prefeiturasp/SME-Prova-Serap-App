import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/widgets/cards/prova_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:appserap/models/prova.model.dart';
import 'package:appserap/controllers/prova.controller.dart';
import 'package:get_it/get_it.dart';
import 'package:appserap/stores/prova.store.dart';

class ProvasAterioresTabPage extends StatefulWidget {
  const ProvasAterioresTabPage({Key? key}) : super(key: key);

  @override
  _ProvasAterioresTabPageState createState() => _ProvasAterioresTabPageState();
}

class _ProvasAterioresTabPageState extends State<ProvasAterioresTabPage> {
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
        child: Container(
          height: MediaQuery.of(context).size.height - 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/sem_prova.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
