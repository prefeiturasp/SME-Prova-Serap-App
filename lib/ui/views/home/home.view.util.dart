import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class HomeViewUtil {
  bool verificaProvaVigente(ProvaStore provaStore) {
    bool provaVigente = false;

    if (provaStore.prova.dataFim != null) {
      DateTime dataAtual = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      DateTime dataInicio = DateTime(
        provaStore.prova.dataInicio.year,
        provaStore.prova.dataInicio.month,
        provaStore.prova.dataInicio.day,
      );

      DateTime dataFim = DateTime(
        provaStore.prova.dataFim!.year,
        provaStore.prova.dataFim!.month,
        provaStore.prova.dataFim!.day,
      );

      provaVigente = dataAtual.isBetween(dataInicio, dataFim);
    }

    if (!provaVigente) {
      provaVigente = isSameDate(provaStore.prova.dataInicio);
    }

    return provaVigente;
  }

  bool verificaProvaDisponivel(ProvaStore provaStore) {
    bool isFinalDeSemanaEPossuiTempo = isFinalDeSemana(DateTime.now()) && provaStore.possuiTempoExecucao();
    bool isFinalDeSemanaENaoPossuiTempo = isFinalDeSemana(DateTime.now()) && !provaStore.possuiTempoExecucao();
    bool naoEFinalDeSemanaEPossuiTempo = !isFinalDeSemana(DateTime.now()) && provaStore.possuiTempoExecucao();
    bool naoEFinalDeSemanaENaoPossuiTempo = !isFinalDeSemana(DateTime.now()) && !provaStore.possuiTempoExecucao();

    bool podeIniciarProva = !isFinalDeSemanaEPossuiTempo ||
        isFinalDeSemanaENaoPossuiTempo ||
        naoEFinalDeSemanaEPossuiTempo ||
        naoEFinalDeSemanaENaoPossuiTempo;

    return podeIniciarProva;
  }

  bool verificaProvaTurno(ProvaStore provaStore, UsuarioStore usuarioStore) {
    bool vigente = false;

    DateTime horaAtual = DateTime.now();
    if (usuarioStore.fimTurno != 0) {
      vigente = horaAtual.hour >= usuarioStore.inicioTurno && horaAtual.hour < usuarioStore.fimTurno;
    } else {
      vigente = horaAtual.hour >= usuarioStore.inicioTurno &&
          (horaAtual.hour <= 23 && horaAtual.minute <= 59 && horaAtual.second <= 59);
    }

    return vigente;
  }
}
