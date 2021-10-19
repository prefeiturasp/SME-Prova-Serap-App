import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.dart';
import 'package:appserap/workers/jobs/baixar_prova.job.dart';
import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';

setupFirebase() async {
  try {
    await fb.Firebase.initializeApp();
    logger.config('[Firebase] Configurando Firebase');
  } catch (e) {
    logger.severe('[Firebase] Falha ao inicializar Firebase');
    logger.severe(e);
  }
}

inscreverTurmaFirebase(String ano) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic(ano);
    logger.config('[Firebase] Inscrevendo no topico do ano $ano');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    logger.severe('[Firebase] Falha ao inscrever no tópico do ano do aluno');
    logger.severe(e);
  }
}

desinscreverTurmaFirebase(String ano) async {
  try {
    await FirebaseMessaging.instance.unsubscribeFromTopic(ano);
    logger.config('[Firebase] Desinscrevendo no topico do ano $ano');
  } catch (e) {
    logger.severe('[Firebase] Falha ao desinscrever no tópico do ano $ano do aluno');
    logger.severe(e);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('RECEBEU UMA MENSAGEM:');

  await await configure();

  await BaixarProvaJob().run();
}
