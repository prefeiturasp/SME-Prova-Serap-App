import 'package:appserap/services/notification_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ApiService {
  late Dio dio;
  //  dio instance to request token
  late Dio tokenDio;

  final usuarioStore = GetIt.I.get<UsuarioStore>();

  ApiService() {
    dio = new Dio();
    tokenDio = new Dio();

    // Descomentar para rodar localhost!
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    dio.interceptors.clear();
    tokenDio.interceptors.clear();
    dio.options.baseUrl = AppConfigReader.getApiHost();
    // dio.options.baseUrl = "https://10.0.2.2:5998/api"; // localhost
    dio.options.connectTimeout = 60 * 1000;
    dio.options.receiveTimeout = 60 * 1000;

    tokenDio.options = dio.options;
    tokenDio.httpClientAdapter = dio.httpClientAdapter;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (usuarioStore.token != "") {
            var headerToken = 'Bearer ${usuarioStore.token}';
            options.headers['Authorization'] = headerToken;
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          switch (e.response?.statusCode) {
            case 401:
            case 403:
              print('401 e 403 - Realizar refresh token');
              // TODO - Ainda não esta 100%!
              final obteveTokenNovo = await refreshToken(e, handler);
              if (obteveTokenNovo) {
                RequestOptions options = e.response!.requestOptions;
                return _retry(options, handler);
              } else {
                return handler.reject(e);
              }
            case 411:
            case 412:
              print('411 e 412 - Erro validação campos login');
              break;
            default:
              if (e.response?.data != '') {
                print(e.response?.data?['mensagens'][0]);
              } else {
                String msgErroInterno =
                    'Ocorreu um erro interno, por favor contate o suporte';
                print(msgErroInterno);
                NotificationService.showSnackbarError(msgErroInterno);
              }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> refreshToken(DioError error, handler) async {
    try {
      // Bloqueio o dio para que todos os pedidos esperem até que a atualização seja concluída primeiro
      dio.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();

      final refreshToken = usuarioStore.token;
      final response = await tokenDio
          .post('/v1/autenticacao/revalidar', data: {'token': refreshToken});

      dio.unlock();
      dio.interceptors.responseLock.unlock();
      dio.interceptors.errorLock.unlock();

      if (response.statusCode == 200) {
        usuarioStore.token = response.data['token'];
      }
      return true;
    } catch (e) {
      dio.unlock();
      dio.interceptors.responseLock.unlock();
      dio.interceptors.errorLock.unlock();

      // TODO - Ainda não esta 100%!
      await usuarioStore.limparUsuario();
      return false;
    }
  }

  Future<void> _retry(options, handler) async {
    try {
      final repostaFetch = await dio.fetch(options);
      if (repostaFetch.statusCode == 200) {
        return handler.resolve(repostaFetch);
      }
    } catch (e) {
      return handler.next(e);
    }
  }
}
