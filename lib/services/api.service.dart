import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ApiService extends http.BaseClient {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_usuarioStore.token != null) {
      request.headers
          .putIfAbsent('Authorization', () => "Bearer ${_usuarioStore.token!}");
    }
    return request.send();
  }
}

// class ApiService {
//   late Dio dio;
//   final usuarioStore = GetIt.I.get<UsuarioStore>();

//   ApiService() {
//     dio = new Dio();
//     dio.interceptors.clear();
//     dio.options.baseUrl =
//         "https://dev-serap-estudante.sme.prefeitura.sp.gov.br/api";
//     //dio.options.baseUrl = "http://10.0.2.2:5999/api";
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           if (usuarioStore.token != "") {
//             var headerToken = 'Bearer ${usuarioStore.token}';
//             options.headers['Authorization'] = headerToken;
//           }
//           return handler.next(options);
//         },
//         // onError: (DioError e, handler) async {
//         //   if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
//         //     await refreshToken();
//         //     //dio.interceptors.requestLock.lock();
//         //     return _retry(e.request);
//         //   }
//         //   return handler.next(e); //continue
//         // If you want to resolve the request with some custom data，
//         // you can resolve a `Response` object eg: return `dio.resolve(response)`.
//         //},
//       ),
//     );
//     //dio.options.baseUrl = AppConfigReader.getApiHost();
//   }

//   // Future<void> refreshToken() async {
//   //   final refreshToken = usuarioStore.token;
//   //   final response = await this
//   //       .dio
//   //       .post('/v1/autenticacao/revalidar', data: {'token': refreshToken});

//   //   if (response.statusCode == 200) {
//   //     usuarioStore.token = response.data['token'];
//   //   }
//   // }

//   // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//   //   final options = new Options(
//   //     method: requestOptions.method,
//   //     headers: requestOptions.headers,
//   //   );
//   //   return this.dio.request<dynamic>(requestOptions.path,
//   //       data: requestOptions.data,
//   //       queryParameters: requestOptions.queryParameters,
//   //       options: options);
//   // }
// }
