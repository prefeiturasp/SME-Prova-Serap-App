import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BarraProgresso extends StatelessWidget {
  final double progresso;
  final Duration tempoRestante;

  const BarraProgresso({
    Key? key,
    this.progresso = 0,
    this.tempoRestante = const Duration(seconds: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.access_time_filled,
              size: 24,
              color: TemaUtil.verde02,
            ),
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 8.0,
              percent: progresso,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.verde02,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Texto('Restam: ', fontSize: 14),
                Texto(formatDuration(tempoRestante), fontSize: 14, bold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
