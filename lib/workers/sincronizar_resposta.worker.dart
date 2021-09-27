import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/stores/prova.store.dart';

class SincronizarRespostas {
  static run() {
    var service = ServiceLocator.get<ProvaStore>();
  }
}
