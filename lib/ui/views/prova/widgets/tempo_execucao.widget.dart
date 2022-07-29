import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/widgets/barras/barra_progresso.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TempoExecucaoWidget extends StatelessWidget {
  final ProvaStore provaStore;

  const TempoExecucaoWidget({
    Key? key,
    required this.provaStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (provaStore.tempoExecucaoStore == null) {
      return SizedBox.shrink();
    }

    return Column(children: [
      Observer(builder: (_) {
        return BarraProgresso(
          progresso: provaStore.tempoExecucaoStore?.porcentagem ?? 0,
          tempoRestante: provaStore.tempoExecucaoStore?.tempoRestante ?? Duration(),
          variant: provaStore.tempoExecucaoStore?.status,
          alerta: provaStore.tempoExecucaoStore!.mostrarAlertaDeTempoAcabando,
        );
      }),
      Observer(builder: (_) {
        return Visibility(
          visible: provaStore.tempoExecucaoStore!.mostrarAlertaDeTempoAcabando,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TemaUtil.laranja01,
            ),
            child: Center(
              child: Texto(
                'Atenção: ${formatDuration(provaStore.tempoExecucaoStore!.tempoRestante)} restantes',
                bold: true,
                fontSize: 16,
                color: TemaUtil.preto,
              ),
            ),
          ),
        );
      }),
    ]);
  }
}
