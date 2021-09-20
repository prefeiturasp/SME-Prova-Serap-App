import 'dart:convert';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/services/download.service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/prova.model.dart';

class CodeRunner {
  static var log = Logger('Auth');

  static Future<void> runCode() async {
    // DownloadService downloadService = GetIt.I.get();

    Prova prova = Prova(
      id: 25,
      descricao: 'descricao',
      itensQuantidade: 0,
      dataInicio: DateTime.now(),
      dataFim: DateTime.now(),
      questoes: [],
      status: EnumDownloadStatus.NAO_INICIADO,
    );

    print('Download iniciado');

    SharedPreferences pref = GetIt.I.get();
    await pref.setString('prova_25', jsonEncode(prova.toJson()));
    await pref.remove('download_25');

    // pref.setString('token',
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJSQSI6IjU3MjA4MjgiLCJBTk8iOiI0IiwibmJmIjoxNjMxOTA2OTI1LCJleHAiOjE2MzE5MTQxMjUsImlzcyI6IlNlcmFwIiwiYXVkIjoiUHJlZmVpdHVyYSBkZSBTYW8gUGF1bG8ifQ.QujyjI0bJv2R6i2vpdFd--IDwdymTzjFVsxp-7QKTpY');

    DownloadService downloadService = DownloadService(idProva: 25);

    await downloadService.configure();

    print('** Total Downloads ${downloadService.downloads.length}');
    print('** Downloads concluidos ${downloadService.getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
    print('** Downloads nao Iniciados ${downloadService.getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

    await downloadService.startDownload((asd, dasd, das) {});

    prova = await downloadService.getProva();

    print(prova);
  }
}
