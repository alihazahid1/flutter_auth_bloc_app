import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  Dio dio = Dio();

  AuthRemoteDataSource({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final newToken = await login('abc@gmail.com', '123456');
            final retryRequest = e.requestOptions;
            retryRequest.headers['Authorization'] = newToken;
          }
          return handler.next(e);
        },
      ),
    );
  }
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        'https://discordapp.com/channels/@me/1394204863381897340/1395005983859806231',
        data: {'email': email, 'password': password},
      );
      await Future.delayed(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        //refresh token
        login(email, password);
        final token = "token:${DateTime.now().millisecondsSinceEpoch}";
        return token;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }
}
