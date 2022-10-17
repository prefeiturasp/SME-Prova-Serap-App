import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/principal.store.dart';

class ProvaMediaUtil {
  verificarDeficienciaVisual() {
    for (var deficiencia in ServiceLocator.get<PrincipalStore>().usuario.deficiencias) {
      if (grupoCegos.contains(deficiencia)) {
        return true;
      }
    }

    return false;
  }

  verificarDeficienciaAuditiva() {
    for (var deficiencia in ServiceLocator.get<PrincipalStore>().usuario.deficiencias) {
      if (grupoSurdos.contains(deficiencia)) {
        return true;
      }
    }

    return false;
  }
}
