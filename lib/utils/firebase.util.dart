import 'package:appserap/main.dart';
import 'package:appserap/workers/jobs/baixar_prova.job.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

setupFirebase() async {
  try {
    logger.config('[Firebase] Configurando Firebase');
    await fb.Firebase.initializeApp();

    await setupCrashlytics();
  } catch (e) {
    logger.severe('[Firebase] Falha ao inicializar Firebase');
    logger.severe(e);
  }
}

setupCrashlytics() async {
  FirebaseCrashlytics.instance.crash();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

inscreverTurmaFirebase(String ano) async {
  try {
    if ((await Connectivity().checkConnectivity()) == ConnectivityStatus.none) {
      return;
    }

    if ((!await Connectivity().checkConnection())) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    logger.config('[Firebase] Inscrevendo no topico do ano $ano');
    await FirebaseMessaging.instance.subscribeToTopic('ano-$ano');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    logger.severe('[Firebase] Falha ao inscrever no tópico do ano do aluno');
    logger.severe(e);
  }
}

desinscreverTurmaFirebase(String ano) async {
  try {
    if ((await Connectivity().checkConnectivity()) == ConnectivityStatus.none) {
      return;
    }

    await FirebaseMessaging.instance.unsubscribeFromTopic('ano-$ano');
    logger.config('[Firebase] Desinscrevendo no topico do ano $ano');
  } catch (e) {
    logger.severe('[Firebase] Falha ao desinscrever no tópico do ano $ano do aluno');
    logger.severe(e);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.info('RECEBEU UMA MENSAGEM:');
  registerPluginsForIsolate();
  await configure();
  await BaixarProvaJob().run();
}
