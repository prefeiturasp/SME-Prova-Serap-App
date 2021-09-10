import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:appserap/stores/usuario.store.dart';

class AutenticacaoInterceptor extends Interceptor {
  final usuarioStore = GetIt.I.get<UsuarioStore>();

  // @override
  // Future onRequest(RequestOptions options) {
  //   if (usuarioStore.token != null) {
  //     var headerToken = 'Bearer ${usuarioStore.token}';
  //     options.headers['Authorization'] = headerToken;
  //   }

  //   return super.onRequest(options);
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    if (usuarioStore.token != "") {
      var headerToken = '${usuarioStore.token}';
      options.headers['Authorization'] = headerToken;
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response!.statusCode == 401) {
      print(err);
    }

    return super.onError(err, handler);
  }
}
