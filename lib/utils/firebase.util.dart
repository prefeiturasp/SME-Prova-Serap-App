import 'dart:io';

import 'package:appserap/main.dart';
import 'package:appserap/workers/jobs/baixar_prova.job.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

setupFirebase() async {
  if (Platform.isWindows || Platform.isLinux) {
    return;
  }

  try {
    logger.config('[Firebase] Configurando Firebase');
    await fb.Firebase.initializeApp();

    await setupCrashlytics();
  } catch (e, stack) {
    logger.severe('[Firebase] Falha ao inicializar Firebase');
    await recordError(e, stack);
  }
}

setupCrashlytics() async {
  if (!kIsWeb && !Platform.isWindows) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}

recordError(
  dynamic exception,
  StackTrace? stack, {
  dynamic reason,
}) async {
  if (!kIsWeb && !Platform.isWindows) {
    await FirebaseCrashlytics.instance.recordError(exception, stack);
  } else {
    print(exception);
    print(stack);
  }
}

setUserIdentifier(String identifier) async {
  if (!kIsWeb && !Platform.isWindows) {
    await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }
}

inscreverTurmaFirebase(String ano) async {
  try {
    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    logger.config('[Firebase] Inscrevendo no topico do ano $ano');
    await FirebaseMessaging.instance.subscribeToTopic('ano-$ano');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  } catch (e, stack) {
    logger.severe('[Firebase] Falha ao inscrever no tópico do ano do aluno');
    await recordError(e, stack);
  }
}

desinscreverTurmaFirebase(String ano) async {
  try {
    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      return;
    }

    await FirebaseMessaging.instance.unsubscribeFromTopic('ano-$ano');
    logger.config('[Firebase] Desinscrevendo no topico do ano $ano');
  } catch (e, stack) {
    logger.severe('[Firebase] Falha ao desinscrever no tópico do ano $ano do aluno');
    await recordError(e, stack);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.info('RECEBEU UMA MENSAGEM:');
  registerPluginsForIsolate();
  await configure();
  await BaixarProvaJob().run();
}
