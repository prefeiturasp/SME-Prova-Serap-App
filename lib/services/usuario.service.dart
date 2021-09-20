import 'package:appserap/models/usuario.model.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UsuarioService {
  final _api = GetIt.I.get<ApiUtil>();

  Future<UsuarioModel> obterDados() async {
    try {
      final response = await _api.dio.get('/v1/autenticacao/meus-dados');
      if (response.statusCode == 200) {
        var usuarioModel = UsuarioModel.fromJson(response.data);
        return usuarioModel;
      }
      return new UsuarioModel(nome: "", ano: "");
    } on DioError catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      return new UsuarioModel(nome: "", ano: "");
    }
  }
}
